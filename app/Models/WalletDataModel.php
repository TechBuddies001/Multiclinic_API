<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class WalletDataModel extends Model
{
    use HasFactory;
    protected $table = 'wallet';
    protected $fillable = [ 'doctor_id','amount'
    ];

}
