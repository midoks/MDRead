<?php

class BaseController extends Yaf_Controller_Abstract{


	public function getUrl(){

		if($_SERVER['SERVER_ADDR'] == '127.0.0.1'){
			return 'http://md.cc/';
		}
		return 'http://121.42.151.169/';
	}

	public function charset($data){
		if( !empty($data) ){
		    $fileType = mb_detect_encoding($data , array('UTF-8','GBK','LATIN1','BIG5')) ;
		    if( $fileType != 'UTF-8'){
		      $data = mb_convert_encoding($data ,'utf-8' , $fileType);
		    }
		}
		return $data;
	}

	public function retJson($array){
		echo json_encode($array);exit;
	}

	public function request($key, $value){
		return $this->getRequest()->getParam($key, $this->getRequest()->getPost($key, $value));
	}

}
?>
