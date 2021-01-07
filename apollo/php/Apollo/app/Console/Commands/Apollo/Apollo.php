<?php

namespace App\Console\Commands\Apollo;

use Illuminate\Console\Command;
use App\Console\Commands\Apollo\ApolloClient;

class Apollo extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'apollo:get';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'get apollo config data';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        $option = config('apollo');
        $ApolloClient = new ApolloClient($option);
        $ApolloClient->start();
    }
}
