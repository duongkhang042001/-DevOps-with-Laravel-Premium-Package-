<?php

namespace App\Checks;

use App\Models\Post;
use Illuminate\Support\Benchmark;
use Spatie\Health\Checks\Check;
use Spatie\Health\Checks\Result;

class QuerySpeedCheck extends Check
{
    public function run(): Result
    {
        $result = Result::make();

        $executionTimeMs = (float) Benchmark::measure(function () {
            Post::with('author')->orderBy('publish_at')->get();
        });

        if ($executionTimeMs >= 50 && $executionTimeMs <= 150) {
            return $result->warning('Database is starting to slow down');
        }

        if ($executionTimeMs > 150) {
            return $result->failed('Database is slow');
        }

        return $result->ok();
    }
}
