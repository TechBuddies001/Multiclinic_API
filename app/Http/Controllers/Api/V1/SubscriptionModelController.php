<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use App\CentralLogics\Helpers;
use Illuminate\Support\Facades\DB;
use App\Models\SubscriptionPlan;
use App\Models\SubscriptionPlanAddons;

class SubscriptionModelController extends Controller
{




    function store(Request $request){

        $subscriptionPlan = SubscriptionPlan::create([
                    'name' => $request->plan_name,
                    'free_type' => json_encode($request->free_type),
                    'paid_type' => json_encode($request->paid_type),
                ]);     
                
        return response()->json([
            'message' => 'Subscription plan created successfully!',
            'data' => $subscriptionPlan
        ], 200); 

    }

    function getData(){       

        $subscriptionPlan = SubscriptionPlan::all();
        $subscriptionPlanAddons = SubscriptionPlanAddons::all();
        return response()->json([
                    'message' => 'Subscription plans retrived successfully!',
                    'data' => [
                        'subscription_plans' => $subscriptionPlan,
                        'subscription_plan_addons' => $subscriptionPlanAddons
                    ]
                ], 200); 
    }


    function storeAddon(Request $request){

        $subscriptionPlanAddons = SubscriptionPlanAddons::create([
            'name' => $request->name,
            'description' => $request->description,
            'price' => $request->price,
            'data' => json_encode($request->data),
        ]);     
        
        return response()->json([
            'message' => 'Subscription addons created successfully!',
            'data' => $subscriptionPlanAddons
        ], 200); 
    }
     

}