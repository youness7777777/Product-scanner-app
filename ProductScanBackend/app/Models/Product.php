<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'barcode',
        'name',
        'brand',
        'nutriscore',
        'image_url',
        'data', // JSON column for full API response if needed
    ];

    protected $casts = [
        'data' => 'array',
    ];

    public function scans()
    {
        return $this->hasMany(Scan::class);
    }

    public function favorites()
    {
        return $this->hasMany(Favorite::class);
    }
}
