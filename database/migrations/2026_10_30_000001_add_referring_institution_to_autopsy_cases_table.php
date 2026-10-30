<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasColumn('autopsy_cases', 'referring_institution')) {
            Schema::table('autopsy_cases', function (Blueprint $table) {
                $table->string('referring_institution')->nullable();
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('autopsy_cases', 'referring_institution')) {
            Schema::table('autopsy_cases', function (Blueprint $table) {
                $table->dropColumn('referring_institution');
            });
        }
    }
};