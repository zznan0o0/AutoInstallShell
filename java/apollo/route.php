<?php


# sunaloe/apollo-laravel
# php artisan apollo:work
Route::get('/apollo', function(){
    return env('apollo:db_name');
});

