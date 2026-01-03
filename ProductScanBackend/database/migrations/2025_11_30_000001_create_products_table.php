<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->string('barcode')->unique();
            $table->string('name')->nullable();
            $table->string('brand')->nullable();
            $table->string('nutriscore')->nullable();
            $table->string('image_url')->nullable();
            $table->json('data')->nullable(); // Store full JSON from API
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('products');
    }
};
