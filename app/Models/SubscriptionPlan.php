<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SubscriptionPlan extends Model
{
    
    use HasFactory;

    protected $table = 'subscription_models';

    protected $fillable = ['name', 'free_type', 'paid_type'];

    protected $casts = [
        'free_type' => 'array', // Automatically converts JSON to an array
        'paid_type' => 'array',
    ];
}
