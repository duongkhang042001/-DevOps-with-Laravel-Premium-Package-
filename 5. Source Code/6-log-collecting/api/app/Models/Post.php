<?php

namespace App\Models;

use App\Events\PostPublishedEvent;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Facades\Storage;

class Post extends Model
{
    use HasFactory;

    protected $guarded = [];

    protected $casts = [
        'publish_at' => 'date',
    ];

    public function author(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function getCoverPhotoUrl(): string
    {
        if (config('filesystems.default') === 's3') {
            return Storage::disk('s3')->temporaryUrl($this->cover_photo_path, now()->addMinutes(10));
        } else {
            return Storage::url('post_cover_photos/' . $this->cover_photo_path);
        }
    }

    public function publish(): void
    {
        $this->publish_at = now();

        $this->is_published = true;

        $this->save();

        PostPublishedEvent::dispatch($this);
    }
}
