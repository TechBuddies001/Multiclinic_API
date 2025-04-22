<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\AppointmentInvoiceModel;
use App\Models\AllTransactionModel;
use PDF;
use Illuminate\Support\Facades\Validator;
use App\CentralLogics\Helpers;
use Illuminate\Support\Facades\DB;

class AppointmentInvoiceController extends Controller
{
  public function generatePDF($id)
  {
      $invoice = DB::table("appointment_invoice")
      ->select('appointment_invoice.*',
      'patients.f_name as patient_f_name',
      'patients.l_name as patient_l_name',
      'patients.phone as patient_phone',
      'users.f_name as user_f_name',
      'users.l_name as user_l_name',
      'users.phone as user_phone',
      )
      ->LeftJoin('patients','patients.id','=','appointment_invoice.patient_id')
      ->LeftJoin('users','users.id','=','appointment_invoice.user_id')
          ->where("appointment_invoice.id", "=", $id)
          ->first();
  
      if (!$invoice) {
          return response()->json(['error' => 'Invoice not found'], 404);
      }
  
      $invoiceItems = DB::table("appointments_invoice_item")
          ->select('appointments_invoice_item.*')
          ->where("appointments_invoice_item.invoice_id", "=", $id)
          ->get();
      $invoice->items = $invoiceItems;
      
      $clinicsDetails=DB::table('clinics')
        ->where('id', '=', $invoice->clinic_id)
        ->first();

      $invoice->clinic_name =  $clinicsDetails->title??"--";
      $invoice->logo =  $clinicsDetails->image??"--";

      $invoice->phone =  $clinicsDetails->phone??"--";

      $invoice->phone_second = $clinicsDetails->phone_second??"--";
     
      $invoice->email = $clinicsDetails->email??"--";
      $invoice->address =  $clinicsDetails->address??"--";
      
     $pdf = PDF::loadView('invoice.pdf', ['invoice' => $invoice]);
     return $pdf->stream('invoice.pdf', ['Attachment' => false]);
  }

  function getDataByAppId($id)
    {
      $data = DB::table("appointment_invoice")
      ->select('appointment_invoice.*',
      'patients.f_name as patient_f_name',
      'patients.l_name as patient_l_name',
      'users.f_name as user_f_name',
      'users.l_name as user_l_name'
      )
      ->LeftJoin('patients','patients.id','=','appointment_invoice.patient_id')
      ->LeftJoin('users','users.id','=','appointment_invoice.user_id')
      ->Where('appointment_invoice.appointment_id','=',$id)
      ->OrderBy('appointment_invoice.created_at','DESC')
        ->first();
        if($data!=null){
            $data->items= DB::table("appointments_invoice_item")
            ->select('appointments_invoice_item.*'
            )
            ->Where('appointments_invoice_item.invoice_id','=',$data->id)
            ->OrderBy('appointments_invoice_item.created_at','ASC')
              ->get();
        }

            $response = [
                "response"=>200,
                'data'=>$data,
            ];
        
      return response($response, 200);
        }

      
    function getDataById($id)
    {
      $data = DB::table("appointment_invoice")
      ->select('appointment_invoice.*',
      'patients.f_name as patient_f_name',
      'patients.l_name as patient_l_name',
      'users.f_name as user_f_name',
      'users.l_name as user_l_name'
      )
      ->LeftJoin('patients','patients.id','=','appointment_invoice.patient_id')
      ->LeftJoin('users','users.id','=','appointment_invoice.user_id')
      ->Where('appointment_invoice.id','=',$id)
      ->OrderBy('appointment_invoice.created_at','DESC')
        ->first();
        if($data!=null){
            $data->items= DB::table("appointments_invoice_item")
            ->select('appointments_invoice_item.*'
            )
            ->Where('appointments_invoice_item.invoice_id','=',$data->id)
            ->OrderBy('appointments_invoice_item.created_at','ASC')
              ->get();
        }

            $response = [
                "response"=>200,
                'data'=>$data,
            ];
        
      return response($response, 200);
        }

    
        public function getData(Request $request)
        {
            // Define the base query
            $query = DB::table("appointment_invoice")
                ->select(
                    'appointment_invoice.*',
                    'patients.f_name as patient_f_name',
                    'patients.l_name as patient_l_name',
                    'users.f_name as user_f_name',
                    'users.l_name as user_l_name',
                    'appointments.doct_id'
                )
                ->leftJoin('patients', 'patients.id', '=', 'appointment_invoice.patient_id')
                ->leftJoin('users', 'users.id', '=', 'appointment_invoice.user_id')
                ->leftJoin('appointments', 'appointments.id', '=', 'appointment_invoice.appointment_id')
                ->orderBy('appointment_invoice.created_at', 'DESC');
        
            // Apply filters efficiently
            if ($request->filled('doctor_id')) {
                $query->where('appointments.doct_id', $request->doctor_id);
            }
        
            if ($request->filled('clinic_id')) {
                $query->where('appointment_invoice.clinic_id', $request->clinic_id );
            }
            if ($request->filled('appointment_id')) {
                $query->where('appointment_invoice.appointment_id', $request->appointment_id );
            }
            if ($request->filled('start_date')) {
                $query->whereDate('appointment_invoice.invoice_date', '>=', $request->start_date);
            }
        
            if ($request->filled('end_date')) {
                $query->whereDate('appointment_invoice.invoice_date', '<=', $request->end_date);
            }
        
            // Apply search filter
            if ($request->filled('search')) {
                $search = $request->input('search');
                $query->where(function ($q) use ($search) {
                    $q->whereRaw('CONCAT(patients.f_name, " ", patients.l_name) LIKE ?', ["%$search%"])
                        ->orWhereRaw('CONCAT(users.f_name, " ", users.l_name) LIKE ?', ["%$search%"])
                        ->orWhere('appointment_invoice.id', 'like', "%$search%")
                        ->orWhere('appointment_invoice.user_id', 'like', "%$search%")
                        ->orWhere('appointment_invoice.patient_id', 'like', "%$search%")
                        ->orWhere('appointment_invoice.appointment_id', 'like', "%$search%")
                        ->orWhere('appointment_invoice.status', 'like', "%$search%")
                        ->orWhere('appointment_invoice.total_amount', 'like', "%$search%")
                        ->orWhere('appointment_invoice.invoice_date', 'like', "%$search%");
                });
            }
        
            // Handle pagination efficiently
            $total_record = $query->count();
        
            if ($request->filled(['start', 'end'])) {
                $query->skip($request->start)->take($request->end - $request->start);
            }
        
            $data = $query->get();
        
            return response()->json([
                "response" => 200,
                "total_record" => $total_record,
                "data" => $data,
            ], 200);
        }
    }
        
