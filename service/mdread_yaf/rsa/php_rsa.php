<?php
//私钥生成
//openssl genrsa -out rsa_private_key.pem 1024
//秘钥生成
//openssl rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem



$config = array(
		"digest_alg" => "sha512",
		"private_key_bits" => 1024,
		"private_key_type" => OPENSSL_KEYTYPE_RSA,
		);
$res = openssl_pkey_new($config);
$private_key = '';
openssl_pkey_export($res, $private_key);
$details = openssl_pkey_get_details($res);
$public_key = $details["key"];

// echo "=====================\n";
// echo "create private key and public key:\n";
// echo "# PRIVATE:\n";
// echo str_replace("\n", "\\n", $private_key) . "\n";
// echo "# PUBLIC:\n";
// echo str_replace("\n", "\\n", $public_key) . "\n";
// var_dump($private_key, $public_key);
// echo "=====================\n";
// echo "\n\n\n";

//var_dump($private_key, $public_key);
//exit;

$public_key = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI2bvVLVYrb4B0raZgFP60VXY\ncvRmk9q56QiTmEm9HXlSPq1zyhyPQHGti5FokYJMzNcKm0bwL1q6ioJuD4EFI56D\na+70XdRz1CjQPQE3yXrXXVvOsmq9LsdxTFWsVBTehdCmrapKZVVx6PKl7myh0cfX\nQmyveT/eqyZK1gYjvQIDAQAB\n-----END PUBLIC KEY-----";
$private_key = "-----BEGIN PRIVATE KEY-----\nMIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMMjZu9UtVitvgHS\ntpmAU/rRVdhy9GaT2rnpCJOYSb0deVI+rXPKHI9Aca2LkWiRgkzM1wqbRvAvWrqK\ngm4PgQUjnoNr7vRd1HPUKNA9ATfJetddW86yar0ux3FMVaxUFN6F0KatqkplVXHo\n8qXubKHRx9dCbK95P96rJkrWBiO9AgMBAAECgYBO1UKEdYg9pxMX0XSLVtiWf3Na\n2jX6Ksk2Sfp5BhDkIcAdhcy09nXLOZGzNqsrv30QYcCOPGTQK5FPwx0mMYVBRAdo\nOLYp7NzxW/File//169O3ZFpkZ7MF0I2oQcNGTpMCUpaY6xMmxqN22INgi8SHp3w\nVU+2bRMLDXEc/MOmAQJBAP+Sv6JdkrY+7WGuQN5O5PjsB15lOGcr4vcfz4vAQ/uy\nEGYZh6IO2Eu0lW6sw2x6uRg0c6hMiFEJcO89qlH/B10CQQDDdtGrzXWVG457vA27\nkpduDpM6BQWTX6wYV9zRlcYYMFHwAQkE0BTvIYde2il6DKGyzokgI6zQyhgtRJ1x\nL6fhAkB9NvvW4/uWeLw7CHHVuVersZBmqjb5LWJU62v3L2rfbT1lmIqAVr+YT9CK\n2fAhPPtkpYYo5d4/vd1sCY1iAQ4tAkEAm2yPrJzjMn2G/ry57rzRzKGqUChOFrGs\nlm7HF6CQtAs4HC+2jC0peDyg97th37rLmPLB9txnPl50ewpkZuwOAQJBAM/eJnFw\nF5QAcL4CYDbfBKocx82VX/pFXng50T7FODiWbbL4UnxICE0UBFInNNiWJxNEb6jL\n5xd0pcy9O2DOeso=\n-----END PRIVATE KEY-----";


function rsaEncode($msg){
	global $public_key;

	$pub_key = $public_key;
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

function rsaDecode($msg){
	global $private_key;
	//$res = openssl_get_privatekey($private_key);

	$msg = base64_decode($msg);

	$result  = '';
	for($i = 0; $i < strlen($msg); $i+=128) {
		$decrypt = '';
	    $data = substr($msg, $i, 128);
	    openssl_private_decrypt($data, $decrypt, $private_key);
	    $result .= $decrypt;
	}
	//openssl_free_key($res);
	return $result;
}


$content = "你哈！";
$encode_msg = rsaEncode($content);
var_dump($encode_msg);


$decode = rsaDecode($encode_msg);
var_dump($decode);
 
exit;
?>