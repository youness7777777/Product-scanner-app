<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

class FavoriteController extends Controller
{
    public function index(Request $request)
    {
        $favorites = $request->user()->favorites()->with('product')->latest()->get();
        return response()->json($favorites);
    }

    public function store(Request $request)
    {
        $request->validate([
            'barcode' => 'required|exists:products,barcode',
        ]);

        $product = Product::where('barcode', $request->barcode)->firstOrFail();

        // Check if already favorited
        if ($request->user()->favorites()->where('product_id', $product->id)->exists()) {
            return response()->json(['message' => 'Product already in favorites'], 409);
        }

        $favorite = $request->user()->favorites()->create([
            'product_id' => $product->id,
        ]);

        return response()->json($favorite->load('product'), 201);
    }

    public function destroy(Request $request, $barcode)
    {
        $product = Product::where('barcode', $barcode)->firstOrFail();

        $deleted = $request->user()->favorites()->where('product_id', $product->id)->delete();

        if ($deleted) {
            return response()->json(['message' => 'Removed from favorites']);
        }

        return response()->json(['message' => 'Product not found in favorites'], 404);
    }
}
