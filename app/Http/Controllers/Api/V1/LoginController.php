<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class LoginController extends Controller
{
    function checkUserRegMobile(Request $request)
    {
        $validator = Validator::make(request()->all(), [
            'phone' => 'required'
        ]);

        if ($validator->fails())
            return response(["response" => 400], 400);

        $user = User::where('phone', $request->phone)->first();

        if (!$user) {
            return response([
                "response" => 201,
                "status" => false,
                'message' => 'These credentials do not match our records.'
            ], 200);
        } else {
            return response([
                "response" => 201,
                "status" => true,
                'message' => 'User exists'
            ], 200);
        }
    }
    function loginMobile(Request $request)
    {
        $validator = Validator::make(request()->all(), [
            'phone' => 'required'
        ]);

        if ($validator->fails())
            return response(["response" => 400], 400);

        $user = User::where('phone', $request->phone)->where('is_deleted', '=', false)->first();

        if (!$user) {
            return response([
                "response" => 200,
                "status" => false,
                'message' => "Not Exists",
                'data' => null,

            ], 200);
        }
        $user->tokens()->delete();
        $token = $user->createToken('my-app-token')->plainTextToken;


        $response = [
            "response" => 200,
            "status" => true,
            'message' => "Successfully",
            'data' => $user,
            'token' => $token,
        ];

        return response($response, 200);
    }
    function ReLoginMobile(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required',
        ]);

        if ($validator->fails()) {
            return response(["response" => 400], 400);
        }

        $user = User::where('phone', $request->phone)->where('is_deleted', '=', false)->first();

        if (!$user) {
            return response([
                "response" => 200,
                "status" => false,
                'message' => "User does not exist",
                'data' => null,
            ], 200);
        }

        return response([
            "response" => 200,
            "status" => true,
            'message' => "Successfully retrieved user data",
            'data' => $user,
        ], 200);
    }



    function login(Request $request)
    {
        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response([
                "response" => 201,
                "status" => false,
                'message' => 'These credentials do not match our records.'
            ], 200);
        }
        $user->tokens()->delete();
        $token = $user->createToken('my-app-token')->plainTextToken;


        $user->role = DB::table("users_role_assign")
            ->select(
                'users_role_assign.*',
                'roles.name as name',
            )
            ->Join('roles', 'roles.id', '=', 'users_role_assign.role_id')
            ->where('users_role_assign.user_id', '=', $user->id)
            ->get();

    
            $clinic = DB::table("clinics")
            ->select(
                'clinics.id',
                 'clinics.title'
            )
            ->where('clinics.user_id', '=', $user->id)
            ->first();

            if($clinic){

                $user->clinic_id=   $clinic->id;
                $user->clinic_title=   $clinic->title;
            }

           
            $doctors = DB::table("doctors")
            ->select(
                'doctors.clinic_id',
            )
            ->where('doctors.user_id', '=', $user->id)
            ->first();
            if($doctors){

                $user->assign_clinic_id=   $doctors->clinic_id;
               
            }

        $response = [
            "response" => 200,
            "status" => true,
            'message' => "Successfully",
            'data' => $user,
            //  'roles'=> $roles, 
            'token' => $token,
        ];

        return response($response, 200);
    }


    public function logout(Request $request) 
    {
        // Get the authenticated user
        $user = $request->user();
    
        // Revoke the current user's token
        $user->currentAccessToken()->delete();
    
        // Update FCM and web FCM tokens to null
        $user->update([
            'fcm' => null,
            'web_fcm' => null,
        ]);
    
        $dataModel= User::where("id", $user->id)->first();
        $dataModel->fcm = null ;
        $dataModel->web_fcm = null ;
        $dataModel->save();
        return response([
            "response" => 200,
            "status" => true,
            "message" => "Logged out successfully."
        ], 200);
    }
}
