<?php

use EurekaClient\EurekaClient;
use EurekaClient\Instance\Instance;
use EurekaClient\Instance\Metadata;
use EurekaClient\Instance\DataCenterInfo;
use GuzzleHttp\Client;

Route::get('/', function () {
    return 'aaa';
});


Route::get('/test2', 'Test@test');

Route::post('/test', 'Test@getInfo');

Route::post('/save','Test@save');

Route::get('/eureka_init', function(){
    $client = new \Eureka\EurekaClient([
        'eurekaDefaultUrl' => 'http://192.168.10.173:5000/eureka',
        'hostName' => 'test.hamid.work',
        'appName' => 'springbootService',
        'ip' => '192.168.10.52',
        'port' => ['82', true],
        'homePageUrl' => 'http://192.168.10.52:82',
        'statusPageUrl' => 'http://192.168.10.52:82/info',
        'healthCheckUrl' => 'http://192.168.10.52:82/health'
    ]);

    return $client->deRegister();
});

Route::get('/eureka_init2', function(){
    // We will use app name and instance id for making requests below.
    $appName = 'springcloudService';
    $instanceId = 'test_instance_id';

    // Create app instance metadata.
    $metadata = new Metadata();
    $metadata->set('test_key', 'test_value');

    // Create data center metadata (required for Amazon only).
    $dataCenterMetadata = new Metadata();
    $dataCenterMetadata->set('data_center_test_key', 'data_center_test_value');

    // Create data center info (Amazon example).
    $dataCenterInfo = new DataCenterInfo();
    $dataCenterInfo
    ->setName('Amazon')
    ->setClass('com.netflix.appinfo.AmazonInfo')
    ->setMetadata($dataCenterMetadata);

    // Create data center info (Own Data Center).
    $dataCenterInfo = new DataCenterInfo();
    $dataCenterInfo
    ->setName('MyOwn')
    ->setClass('com.netflix.appinfo.MyDataCenterInfo');

    // Create Eureka app instance.
    $instance = new Instance();
    $instance
    ->setInstanceId($instanceId)
    ->setHostName('test_host_name')
    ->setApp($appName)
    ->setIpAddr('127.0.0.1')
    ->setPort(80)
    ->setSecurePort(433)
    ->setHomePageUrl('http://localhost')
    ->setStatusPageUrl('http://localhost/status')
    ->setHealthCheckUrl('http://localhost/health-check')
    ->setSecureHealthCheckUrl('https://localhost/health-check')
    ->setVipAddress('test_vip_address')
    ->setSecureVipAddress('test_secure_vip_address')
    ->setMetadata($metadata)
    ->setDataCenterInfo($dataCenterInfo);
});

Route::get('/eureka', function(){
    return ["status" => "UP"];
});

Route::put('/eureka', function(){
    return ["status" => "UP"];
});

Route::post('/service/hello', function(){
    $name = Request::input('name');
    return [
        "result" => "Success",
        "data" => "ServicePHP:Welcome " . $name . "!",
        "cntPage" => 0,
        "cntData" => 0,
    ];
});

Route::get('/health', function(){
    return ["status" => "UP"];
});
