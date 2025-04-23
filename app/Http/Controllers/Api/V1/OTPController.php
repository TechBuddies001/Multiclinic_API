<?php

namespace App\Http\Controllers\Api\V1;


use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Carbon\Carbon;

class OTPController extends Controller
{
    // Generate OTP
    public function generateOtp(Request $request)
    {
        $request->validate([
            'email' => 'required|email', // Or phone number, depending on use case
        ]);

        $email = $request->input('email');
        $otp = rand(100000, 999999); // 6-digit OTP

        // Store OTP in the database along with expiration time
        DB::table('otp_records')->updateOrInsert(
            ['email' => $email],
            ['otp' => Hash::make($otp), 'expires_at' => Carbon::now()->addMinutes(5)] // 5-minute expiration
        );

        // Send OTP to user (via email for this example)
        Mail::to($email)->send(new \App\Mail\OtpMail($otp));

        return response()->json([
            'message' => 'OTP sent successfully!',
            'email' => $email
        ]);
    }

    // Verify OTP
    public function verifyOtp(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'otp' => 'required|numeric',
        ]);

        $email = $request->input('email');
        $otp = $request->input('otp');
        
        // Fetch OTP record from DB
        $otpRecord = DB::table('otp_records')->where('email', $email)->first();

        if (!$otpRecord) {
            return response()->json(['message' => 'No OTP found for this email.'], 400);
        }

        // Check if OTP is expired
        if (Carbon::now()->gt(Carbon::parse($otpRecord->expires_at))) {
            return response()->json(['message' => 'OTP has expired.'], 400);
        }

        // Verify OTP (using Hash::check because we're storing the hashed OTP)
        if (Hash::check($otp, $otpRecord->otp)) {
            return response()->json(['message' => 'OTP verified successfully!']);
        } else {
            return response()->json(['message' => 'Invalid OTP.'], 400);
        }
    }
}
