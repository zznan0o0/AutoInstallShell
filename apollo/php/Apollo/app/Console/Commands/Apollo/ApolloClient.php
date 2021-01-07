<?php
namespace App\Console\Commands\Apollo;
/**
 * 携程apollo laravel客户端
 * @param Array $option
 * --- eg: start ---
 * [
 *     'config_server_url' => 'http://localhost:8080', //apollo config service address
 *     'appId' => 'test', //appid
 *     'clusterName' => 'default', // clusterName default default
 *     'namespaceName' => 'application', // namespaceName default application
 *     'clientIp' => null, // clientIp  灰度发布时候指定ip
 *     'envDir' => './.env' // .env file directory default ./.env
 * ];
 * --- eg: end   ---
 */
class ApolloClient{
    public function __construct($option=[]){
        $defaultOption = [
            'config_server_url' => 'http://localhost:8080',
            'appId' => 'test',
            'clusterName' => 'default',
            'namespaceName' => 'application',
            'clientIp' => null,
            'envDir' => './.env'
        ];

        foreach($option as $k => $v){
            $defaultOption[$k] = $v;
        }

        $this->defaultOption = $defaultOption;
    }

    /**
     * exec function
     */
    public function start(){
        $this->getFromConfigfiles();
    }


    /**
     * http get apollo data
     */
    public function getFromConfigfiles(){
        // {config_server_url}/configfiles/json/{appId}/{clusterName}/{namespaceName}?ip={clientIp}
        // $url = 'http://192.168.2.201:8081/configfiles/json/test/default/application';
        $url = $this->defaultOption['config_server_url'] . '/configfiles/json/' . $this->defaultOption['appId'] . '/' . $this->defaultOption['clusterName'] . '/' . $this->defaultOption['namespaceName'];

        if($this->defaultOption['clientIp']){
            $url = $url . '?ip=' . $this->defaultOption['clientIp'];
        }

        $reslut = $this->get($url, null);
        $data = json_decode($reslut['content'], true);
        if($reslut['header']['http_code'] == 200 && is_array($data)){
            // var_dump($data);
            $write_content = "";
            foreach($data as $k => $v){
                $write_content = $write_content . $k . '=' . $v . "\n";
            }
            $this->wirite($this->defaultOption['envDir'], $write_content);

        }
        else{
            echo "Apollo Error: ------------\n";
            echo "http_code: " . $reslut['header']['http_code'] . "\n";
            echo $reslut['content'] . "\n";
        }
    }

    /**
     * write file
     */
    public function wirite($filename, $content){
        $file = fopen($filename, 'w');
        fwrite($file, $content);
        fclose($file);
    }

    /**
     * http Get request
     */
    public function get($url,$data){

        if($data){
            $url = $url . "?";
            $arr = [];
            foreach ($data as $k => $v) {
            $arr[] = $k . '=' . $v;
            }
            $url .= join('&',$arr);
        }

        $curl = curl_init(); // 启动一个CURL会话
        curl_setopt($curl, CURLOPT_URL, $url);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        // curl_setopt($curl, CURLOPT_HEADER, true);
        // curl_setopt($curl, CURLOPT_NOBODY, true);
        // curl_setopt($curl, CURLOPT_ENCODING, "gzip" );
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);//绕过ssl验证
        curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);

        //执行并获取HTML文档内容
        $output = curl_exec($curl);

        $headerSize = curl_getinfo($curl, CURLINFO_HEADER_SIZE);
        $header = curl_getinfo($curl);
        // $content =
        // 根据头大小去获取头信息内容
        // $header = substr($output, 0, $headerSize);
        // var_dump($header);
        // var_dump($output);
        // var_dump($header['http_code']);
        // echo $header;
        //释放curl句柄
        curl_close($curl);
        return ['header' => $header, 'content' => $output];
    }

    public function getVal($d, $k, $initval){
        if($d === null) return $initval;
        if(array_key_exists($k, $d)){
            return $d[$k];
        }
        return $initval;
    }
}

