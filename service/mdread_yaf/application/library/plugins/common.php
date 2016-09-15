<?php

/**
 * 保证文件存在
 * @parma 目录路径
 */
function mkdir_p($absdir){
	$absdir = str_replace('\\', '/', $absdir);
	$absdir = rtrim($absdir, '/');
	if(file_exists($absdir)){
		return true;
	}
	$pre_dir = dirname($absdir);
	if(!file_exists($pre_dir)){
		mkdir_p($pre_dir);
	}
	return mkdir($absdir);
}



function curlPost($url, $data){
	$ch = curl_init();
	curl_setopt($ch , CURLOPT_URL , $url);
	curl_setopt($ch , CURLOPT_HEADER , 0);
	curl_setopt($ch , CURLOPT_POST, 1 );
	curl_setopt($ch , CURLOPT_POSTFIELDS, $data);
	curl_setopt($ch , CURLOPT_FOLLOWLOCATION , 1);
	curl_setopt($ch , CURLOPT_MAXREDIRS , 10);
	curl_setopt($ch , CURLOPT_HEADER , 0 );
	curl_setopt($ch , CURLOPT_RETURNTRANSFER , 1);
	$data = curl_exec( $ch );
	curl_close( $ch ); 	
	return $data;
}

function openUrl($url){
	$ch = curl_init();
	curl_setopt($ch , CURLOPT_URL , $url);
	curl_setopt($ch , CURLOPT_HEADER , 0);
	curl_setopt($ch , CURLOPT_FOLLOWLOCATION , 1);
	curl_setopt($ch , CURLOPT_MAXREDIRS , 10);
	curl_setopt($ch , CURLOPT_HEADER , 0 );
	curl_setopt($ch , CURLOPT_RETURNTRANSFER , 1);
	$data = curl_exec( $ch );
	curl_close( $ch ); 	
	return $data;
}

function get_client_ip(){
	static $ip = null;
	if($ip != null) return $ip;
	if( isset( $_SERVER['HTTP_X_FORWARDED_FOR'] ) ){
		$arr = explode( ',' ,$_SERVER['HTTP_X_FORWARDED_FOR'] );
		$pos = array_search( 'unknown' , $arr );
		if( false !=$pos ) unset($arr[$pos]);
		$ip = trim( $arr[0] );
	}elseif( isset( $_SERVER['HTTP_CLIENT_IP'] ) ){
		$ip = $_SERVER['HTTP_CLIENT_IP'];
	}elseif( isset($_SERVER['REMOTE_ADDR'] ) ){
		$ip = $_SERVER['REMOTE_ADDR'];
	}
	//检查IP地址的合法性
	$ip = (false!==ip2long($ip)) ? $ip : '0,0,0,0';
	return $ip;
}

/**
 * 本地文件上传
 * @param $url_filename 本地文件地址
 */
function file_upload($url_filename){

	if (class_exists('\CURLFile')) {
        $files_data = array('uid'=>$uid,'Filedata'=>new \CURLFile(realpath($url_filename)));
    } else {
        $files_data = array('uid'=>$uid,'Filedata'=>"@".$url_filename);
    }

    $api_url = 'http://url';
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
    curl_setopt($ch, CURLOPT_POST, TRUE);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $files_data);
    curl_setopt($ch, CURLOPT_URL, $api_url);
    $ret = curl_exec($ch);
    curl_close($ch);
    return $ret;
}


function download_image($url){
	$image 	= openUrl($url);
	$fn 	= basename($url);

	$ip = get_client_ip();
	$d_dir 	= APP_PATH.'static/images/'.date('Y/m/d');
	if( '127.0.0.1' == $ip){
		$d_dir = APP_PATH.'static/test/'.date('Y/m/d');
	}
	
	mkdir_p($d_dir);
	$d_fn = $d_dir.'/'.$fn;
	$r = file_put_contents($d_fn, $image);
	if($r){
		return date('Y/m/d').'/'.$fn;
	}
	return false;
}

function getContentImage($content) {
    $imageList = array();
    if (stripos($content, '<img') !== false) {
        preg_match_all('/<img[^<>]*src=[\'|\"]*([^\'\"\s>]+)[\'|\"]*[^<]+>/i',$content, $oriImageList);
        $imgList = $oriImageList[1];
        foreach ($imgList as $img) {
            $imageList[] = $img;
        }
    }
    return $imageList;
}
?>