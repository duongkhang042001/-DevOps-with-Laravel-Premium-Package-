<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\PostController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::post('/auth/login', [AuthController::class, 'login']);

Route::get('/health-check', function () {
    return response('', 200);
});

Route::middleware('auth:sanctum')->group(function () {
    Route::get('posts/export', [PostController::class, 'export'])->name('posts.export');

    Route::patch('posts/{post}/publish', [PostController::class, 'publish'])->name('posts.publish');

    Route::apiResource('posts', PostController::class);
});
