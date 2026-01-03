<?php

namespace App\Http\Controllers;

use App\Models\Product;
use App\Models\Scan;
use Illuminate\Http\Request;

class ScanController extends Controller
{
    public function index(Request $request)
    {
        $scans = $request->user()->scans()->with('product')->latest()->get();
        return response()->json($scans);
    }

    public function store(Request $request)
    {
        $request->validate([
            'barcode' => 'required|exists:products,barcode',
        ]);

        $product = Product::where('barcode', $request->barcode)->firstOrFail();

        $scan = $request->user()->scans()->create([
            'product_id' => $product->id,
        ]);

        return response()->json($scan->load('product'), 201);
    }
}
