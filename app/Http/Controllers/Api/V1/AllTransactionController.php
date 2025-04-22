<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\AppointmentModel;
use App\Models\AppointmentInvoiceModel;
use App\Models\AppointmentPaymentModel;
use App\Models\AppointmentStatusLogModel;
use App\Models\AppointmentInvoiceItemModel;
use App\Models\AllTransactionModel;
use App\Models\User;
use Illuminate\Support\Facades\Validator;
use App\CentralLogics\Helpers;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;
use App\Http\Controllers\Api\V1\NotificationCentralController;

class AllTransactionController extends Controller
{

  function updateWalletMoneyData(Request $request)
  {

    $validator = Validator::make(request()->all(), [
      'user_id' => 'required',
      'amount' => 'required',
      'payment_transaction_id' => 'required',
      'payment_method' => 'required',
      'transaction_type' => 'required',
      'description' => 'required'

    ]);
    // dd($request->all());
    if ($validator->fails())
      //return response (["response"=>400],400);
      return response()->json($validator->errors(), 400);
    else {
      try {
        DB::beginTransaction();
        $date = date("Y-m-d");

        $timeStamp = date("Y-m-d H:i:s");
        $dataModel = new AllTransactionModel;
        $dataModel->user_id  = $request->user_id;
        $dataModel->payment_transaction_id  = $request->payment_transaction_id;
        $dataModel->is_Wallet_txn = 1;
        $dataModel->amount = $request->amount;

        $dataModel->transaction_type  =  $request->transaction_type;

        $dataModel->created_at = $timeStamp;
        $dataModel->updated_at = $timeStamp;

        $qResponce = $dataModel->save();
        if (!$qResponce) {
          DB::rollBack();
          return Helpers::errorResponse("error");
        }

        $dataInvoiceModel = new AppointmentInvoiceModel;
        $dataInvoiceModel->user_id = $request->user_id;
        $dataInvoiceModel->status = "Paid";
        $dataInvoiceModel->total_amount  = $request->amount;
        $dataInvoiceModel->invoice_date = $date;
        $dataInvoiceModel->created_at = $timeStamp;
        $dataInvoiceModel->updated_at = $timeStamp;

        $qResponceInvoice = $dataInvoiceModel->save();
        if (!$qResponceInvoice) {
          DB::rollBack();
          return Helpers::errorResponse("error");
        }


        $dataInvoiceItemModel = new AppointmentInvoiceItemModel;
        $dataInvoiceItemModel->invoice_id = $dataInvoiceModel->id;
        $dataInvoiceItemModel->description  = $request->description;
        $dataInvoiceItemModel->quantity = 1;
        $dataInvoiceItemModel->unit_price  = $request->amount;
        $dataInvoiceItemModel->service_charge =  0;
        $dataInvoiceItemModel->total_price = $request->amount;

        $dataInvoiceItemModel->created_at = $timeStamp;
        $dataInvoiceItemModel->updated_at = $timeStamp;

        $qResponceInvoiceItem = $dataInvoiceItemModel->save();

        if (!$qResponceInvoiceItem) {
          DB::rollBack();
          return Helpers::errorResponse("error");
        }

        $dataPaymentModel = new AppointmentPaymentModel;
        $dataPaymentModel->txn_id = $dataModel->id;
        $dataPaymentModel->invoice_id   = $dataInvoiceModel->id;
        $dataPaymentModel->amount   = $request->amount;
        $dataPaymentModel->payment_time_stamp   = $timeStamp;
        $dataPaymentModel->payment_method   = $request->payment_method;
        $dataPaymentModel->created_at = $timeStamp;
        $dataPaymentModel->updated_at = $timeStamp;
        $qResponcePayment = $dataPaymentModel->save();
        if (!$qResponcePayment) {
          DB::rollBack();
          return Helpers::errorResponse("error");
        }

        $dataModelUser = User::where("id", $request->user_id)->first();

        if ($dataModelUser == null) {
          DB::rollBack();
          return Helpers::errorResponse("error");
        }

        $oldAmount = $dataModelUser->wallet_amount ?? 0;
        $newAmount = $request->transaction_type == "Credited" ? $oldAmount + $request->amount : $oldAmount - $request->amount;
        $dataModelUser->wallet_amount  = $newAmount;
        $walletUpdateRes = $dataModelUser->save();

        if (!$walletUpdateRes) {
          DB::rollBack();
          return Helpers::errorResponse("error");
        }


        $dataModel->last_wallet_amount = $oldAmount;
        $dataModel->new_wallet_amount = $newAmount;
        $qResponceTrUpdate = $dataModel->save();
        if (!$qResponceTrUpdate) {
          DB::rollBack();
          return Helpers::errorResponse("error");
        }
        DB::commit();

        $notificationCentralController = new NotificationCentralController();
        $notificationCentralController->sendWalletNotificationToUsers($request->user_id, $request->transaction_type, $request->amount, $dataModel->id);

        return Helpers::successWithIdResponse("successfully", $dataModel->id);
      } catch (\Exception $e) {

        return Helpers::errorResponse("error $e");
      }
    }
  }




  function getDataById($id)
  {
    $data = DB::table("all_transaction")
      ->select(
        'all_transaction.*',
        'patients.f_name as patient_f_name',
        'patients.l_name as patient_l_name',
        'users.f_name as user_f_name',
        'users.l_name as user_l_name'
      )
      ->LeftJoin('patients', 'patients.id', '=', 'all_transaction.patient_id')
      ->LeftJoin('users', 'users.id', '=', 'all_transaction.user_id')
      ->Where('all_transaction.id', '=', $id)
      ->OrderBy('all_transaction.created_at', 'DESC')
      ->first();

    $response = [
      "response" => 200,
      'data' => $data,
    ];

    return response($response, 200);
  }




  public function getData(Request $request)
  {
    // Define the base query
    $query = DB::table("all_transaction")
      ->select(
        'all_transaction.*',
        'patients.f_name as patient_f_name',
        'patients.l_name as patient_l_name',
        'users.f_name as user_f_name',
        'users.l_name as user_l_name',
        'appointments.doct_id'
      )
      ->leftJoin('patients', 'patients.id', '=', 'all_transaction.patient_id')
      ->leftJoin('users', 'users.id', '=', 'all_transaction.user_id')
      ->leftJoin('appointments', 'appointments.id', '=', 'all_transaction.appointment_id')
      ->orderBy('all_transaction.created_at', 'DESC');

    // Apply filters efficiently
    if ($request->filled('appointment_id')) {
      $query->Where('all_transaction.appointment_id', '=', $request->appointment_id);
    }
    // Apply filters efficiently
    if ($request->filled('doctor_id')) {
      $query->where('appointments.doct_id', $request->doctor_id);
    }

    if ($request->filled('user_id')) {
      $query->where("all_transaction.user_id", "=", $request->user_id);
    }


    if ($request->filled('is_wallet_txn')) {
      $query->where("all_transaction.is_wallet_txn", "=", $request->is_wallet_txn);
    }
    if ($request->filled('clinic_id')) {
      $query->where("all_transaction.clinic_id", "=", $request->clinic_id);
    }


    if ($request->filled('start_date')) {
      $query->whereDate('all_transaction.created_at', '>=', $request->start_date);
    }

    if ($request->filled('end_date')) {
      $query->whereDate('all_transaction.created_at', '<=', $request->end_date);
    }

    // Apply search filter
    if ($request->filled('search')) {
      $search = $request->input('search');
      $query->where(function ($q) use ($search) {
        $q->whereRaw('CONCAT(patients.f_name, " ", patients.l_name) LIKE ?', ["%$search%"])
          ->orWhereRaw('CONCAT(users.f_name, " ", users.l_name) LIKE ?', ["%$search%"])
          ->orWhere('all_transaction.id', 'like', "%$search%")
          ->orWhere('all_transaction.user_id', 'like', "%$search%")
          ->orWhere('all_transaction.patient_id', 'like', "%$search%")
          ->orWhere('all_transaction.appointment_id', 'like', "%$search%")
          ->orWhere('all_transaction.payment_transaction_id', 'like', "%$search%")
          ->orWhere('all_transaction.amount', 'like', "%$search%")
          ->orWhere('all_transaction.transaction_type', 'like', "%$search%")
          ->orWhere('all_transaction.notes', 'like', "%$search%");
      });
    }
    $total_record = $query->count();
    // Handle start & end for pagination
    if ($request->filled(['start', 'end'])) {
      $start = $request->start;
      $limit = $request->end - $start;
      $query->skip($start)->take($limit);
    }


    $data = $query->get();

    return response()->json([
      "response" => 200,
      "total_record" => $total_record,
      "data" => $data,
    ], 200);
  }
}
