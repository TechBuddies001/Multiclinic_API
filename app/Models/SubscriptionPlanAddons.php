<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SubscriptionPlanAddons extends Model
{
    use HasFactory;

    protected $table = 'subscription_addons';

    protected $fillable = ['name', 'description', 'price','data'];

    protected $casts = [
        'data' => 'array', // Automatically converts JSON to an array
    ];
}
