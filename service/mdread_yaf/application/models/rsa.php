<?php
/**
 * author midoks
 * rsa非对称加密和解密
 */

class rsaModel extends Model{

	public function makeKey(){
		$config = array(
			'digest_alg' => 'sha512',
			'private_key_bits' => 1024,
			'private_key_type' => OPENSSL_KEYTYPE_RSA,
		);
		$res = openssl_pkey_new($config);
		$private_key = '';
		openssl_pkey_export($res, $private_key);
		$details = openssl_pkey_get_details($res);
		$public_key = $details["key"];



		$info['private_key'] = $private_key;
		$info['public_key'] = $public_key;

		return $info;
	}

	public function getPublicKey(){
		$info = $this->makeKeyWC(60);
		return $info['public_key'];


	}

	public function getPrivateKey(){
		$info = $this->makeKeyWC(60);
		return $info['private_key'];
	}


	public function encodeWithPublicKey(){

	}

	public function decodeWithPrivateKey(){

	}







}

?>