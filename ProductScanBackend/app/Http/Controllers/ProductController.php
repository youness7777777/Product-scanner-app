<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class ProductController extends Controller
{
    public function show($barcode)
    {
        // 1. Check if product exists in our DB
        $product = Product::where('barcode', $barcode)->first();

        if ($product) {
            return response()->json($product);
        }

        // 2. If not, fetch from OpenFoodFacts
        $response = Http::get("https://world.openfoodfacts.org/api/v0/product/{$barcode}.json");

        if ($response->successful() && $response['status'] == 1) {
            $data = $response['product'];

            // 3. Cache it in our DB
            $product = Product::create([
                'barcode' => $barcode,
                'name' => $data['product_name'] ?? 'Unknown Product',
                'brand' => $data['brands'] ?? null,
                'nutriscore' => $data['nutriscore_grade'] ?? null,
                'image_url' => $data['image_url'] ?? null,
                'data' => $data,
            ]);

            return response()->json($product);
        }

        return response()->json(['message' => 'Product not found'], 404);
    }
}
