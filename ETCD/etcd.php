<?php

// etcdctl --write-out=table --endpoints=192.168.10.66:2379,192.168.10.35:2379,192.168.10.190:2379 member list
$ENDPOINT = '192.168.10.66:2379,192.168.10.35:2379,192.168.10.190:2379';
$a = 123;

// etcdctl  --endpoints=192.168.10.66:2379,192.168.10.35:2379,192.168.10.190:2379 get aaa

class HandleETCD{
  function __construct($ENDPOINT){
    $this->ENDPOINT = $ENDPOINT;
  }

  public function exec($exec_str){
    exec($exec_str, $output, $return_code);
    return [
      'output' => $output,
      'code' => $return_code
    ];
  }

  public function combinateCMD($cmd_str){
    return 'etcdctl  --endpoints=' . $this->ENDPOINT . ' ' . $cmd_str . ' 2>&1';
  }

  public function iscode($res){
    return isset($res['code']) && $res['code'] === 0;
  }

  public function error($res){
    return ['code' => $res['code'], 'error' => $res['output']];
  }

  public function get($key){
    $exec_str = $this->combinateCMD('get ' . $key);
    $res = $this->exec($exec_str);
    if($this->iscode($res)){
      if(count($res['output']) > 1){
        return ['key' => $res['output'][0], 'value' => $res['output'][1], 'code' => $res['code']];
      }
      else {
        return ['key' => $res['output'][0], 'value' => '', 'code' => $res['code']];
      }
    }
    else{
      return $this->error($res);
    }
  }
}

function postJson($url, $submitData)
{
    $submitData = json_encode($submitData);
    
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
    curl_setopt($ch, CURLOPT_POSTFIELDS, $submitData);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
        'Content-Type: application/json',
        'Content-Length: ' . strlen($submitData)
    ));

    $result = curl_exec($ch);
    if (curl_errno($ch)) {
        return curl_error($ch);
    }
    curl_close($ch);
    return $result;
}

// curl http://127.0.0.1:2379/v3/kv/put -XPOST -d '{"key": "Zm9v", "value":"YmFy"}'
$submit_data = [
  'key' => base64_encode('aaa'),
  // 'value' => base64_encode('bbb1')
];

$res = postJson('http://127.0.0.1:2379/v3/kv/range', $submit_data);
$res = json_decode($res, true);
// var_dump($res);

var_dump(base64_decode($res['kvs'][0]['value']));

// $t1=microtime(true);
// for($i = 0; $i < 100; $i++){
//   $res = postJson('http://127.0.0.1:2379/v3/kv/range', $submit_data);
// }
// $t2=microtime(true);
// var_dump($t2-$t1);

// var_dump($res);

// $HandleETCD = new HandleETCD($ENDPOINT);
// $t1=microtime(true);
// for($i = 0; $i < 100; $i++){
//   $aaa = $HandleETCD->get('aaa');
// }
// $t2=microtime(true);
// var_dump($aaa);
// var_dump($t2-$t1);

// function addEndpoints(){
//   return 'etcdctl  --endpoints=' . $ENDPOINT . ' ';
// }

// function get($key){
//   $cmd_str = addEndpoints() . 'get ' . $key;
//   exec($cmd_str, $output, $return_code);
//   echo $output;
//   echo $return_code;
// }

// get('aaa');