<?php
//私钥生成
//openssl genrsa -out rsa_private_key.pem 1024
//秘钥生成
//openssl rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem


function rsaEncode($msg){

	$pub_key = file_get_contents('file/rsa_public_key.pem');
	//$res = openssl_get_publickey($pub_key);

	$result  = '';
	for($i = 0; $i < strlen($msg); $i+=117) {
		$encrypt = '';
	    $data = substr($msg, $i, 117);
	    openssl_public_encrypt($data, $encrypt, $pub_key);
	    $result .= $encrypt;
	}
	$result = base64_encode($result);
	//openssl_free_key($res);
	return $result;
}


function rsaEncode_s($msg){

	$pub_key = file_get_contents('file/rsa_public_key.pem');
	$res = openssl_get_publickey($pub_key);

	$result  = '';
	for($i = 0; $i < strlen($msg)/128; $i++) {
		$encrypt = '';
	    $data = substr($msg, $i * 128, 128);
	    openssl_public_encrypt($data, $encrypt, $res);
	    $result .= $encrypt;
	}
	$result = base64_encode($result);
	openssl_free_key($res);
	return $result;
}

function rsaDecode($msg){
	
	$private_key = file_get_contents('file/rsa_private_key.pem');
	//$res = openssl_get_privatekey($private_key);

	$msg = base64_decode($msg);

	$result  = '';
	for($i = 0; $i < strlen($msg)/128; $i++) {
		$decrypt = '';
	    $data = substr($msg, $i * 128, 128);
	    openssl_private_decrypt($data, $decrypt, $private_key);
	    $result .= $decrypt;
	}
	//openssl_free_key($res);
	return $result;
}

function rsaDecode_s($msg){
	
	$private_key = file_get_contents('file/rsa_private_key.pem');
	$res = openssl_get_privatekey($private_key);

	$msg = base64_decode($msg);

	$result  = '';
	for($i = 0; $i < strlen($msg); $i+=128) {
		$decrypt = '';
	    $data = substr($msg, $i, 128);
	    openssl_private_decrypt($data, $decrypt, $res);
	    $result .= $decrypt;
	}
	openssl_free_key($res);
	return $result;
}



$content = "憋";
$encode_msg = rsaEncode($content);
var_dump($encode_msg);


$decode = rsaDecode($encode_msg);
var_dump($decode);
 
exit;
?>