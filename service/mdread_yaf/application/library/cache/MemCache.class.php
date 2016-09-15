<?php 

class MemCache{

	public $config = [];

	public $mem = NULL;

	public static $_instance 		= NULL;

	public static function instance(){
		if (!self::$_instance){
			self::$_instance = new MemCache();
		}
		return self::$_instance;
	}

	public function register($config){
		$this->config = $config;

		$this->mem = new Memcache();
		$this->mem->connect($config['ip'], $config['port']);
	}


	public function get($key){
		return $this->mem->get($key);
	}
	
	public function set($key, $value, $timeout){
		return $this->mem->set($key, $value, $timeout);
	}


}

?>