<?php 

final class Logs{

	public $fp = NULL;

	public function w($content){
		$this->debug($content, 'debug');
	}


	//记录日志
	public function debug($content, $fileName = 'content'){
		$filename = APP_PATH.'logs/'.$fileName.'-'.date('Y-m-d').'.txt';
		if(!file_exists($filename)){
			@touch($filename);
			@chmod($filename,0777);//权限改为777
		}
		$fp = fopen($filename, 'a');
		flock($fp,	LOCK_EX) ;
		fwrite($fp, $content."\n");
		flock($fp, 	LOCK_UN);
		fclose($fp);
	}


	public function __destruct(){
		//fclose($this->fp);
	}
	
}

?>