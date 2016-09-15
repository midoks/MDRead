<?php 

class Model{

	public $db = null;
	public $mongo = null;
	public $redis = null;
	public $mem = null;

	public $logs = null;

	public function __construct(){
		$this->_initDb();
		$this->_initMongo();
		$this->_initRedis();
		$this->_initMemcached();

		$this->logs = new Logs();
	}

	public function _initDb(){

		$this->db = mySqlDb::instance();
		$this->db->register(array(
			'master' => [
				['db_host' 			=> '121.42.151.169',
	 			'db_name' 			=> 'mdread',
	 			'db_user' 			=> 'mdread_mac',
	 			'db_pwd'  			=> 'cjs123QW',
	 			'db_charset' 		=> 'utf8',
	 			'db_table_prefix' 	=> 'md_'],
			],
			'slave' => [
				['db_host' 			=> '121.42.151.169',
	 			'db_name' 			=> 'mdread',
	 			'db_user' 			=> 'mdread_mac',
	 			'db_pwd'  			=> 'cjs123QW',
	 			'db_charset' 		=> 'utf8',
	 			'db_table_prefix' 	=> 'md_'],
			],
		));
	}

	public function table($tableName){
		return $this->db->table($tableName);
	}

	public function _initMongo(){

		$this->mongo = mongoSvc::instance();
		$this->mongo->register([
				'conn' 	=> 'mongodb://127.0.0.1:27017',
				'db'	=> 'mdread']);
	}

	public function _initRedis(){

	}

	public function _initMemcached(){
		// $this->mem = new Memcache();
		// $this->mem->connect('127.0.0.1', '11211');

		$this->mem = new Memcached();
		$this->mem->addServer('127.0.0.1', '11211');
	}


	public function __call($method, $args){

		if (substr($method, -2) == 'WC') {
			return $this->cacheMemWC($method, $args);
		} else if (substr($method, -3) == 'WCL'){ 
			return $this->cacheMemWCL($method, $args);
		}
	}


	public function cacheMemWC($method, $args){
		$relFunc = substr($method, 0, strlen($method)-2);
		$cache_time_params = isset($args[0])? $args[0]:1;
		$key = 'sys_m_'.md5($method.serialize($args));
		array_shift($args);

		$data = $this->mem->get($key);
		if( empty($data)  || isset($_GET['_refresh']) ){
			$data = call_user_func_array(array($this, $relFunc), $args);
			if($data){
				$this->mem->set($key, $data, $cache_time_params);
			}
		}
		return $data;
	}

	//解决雪崩事件
	public function cacheMemWCL($method, $args){
		
		$relFunc = substr($method, 0, strlen($method)-3);
		$cache_time_params = isset($args[0])? $args[0]:1;
		$key = 'sys_ml_'.md5($method.serialize($args));
		array_shift($args);

		$data = $this->mem->get($key);
		if($data && !isset($_GET['_refresh'])){
			return $data;
		}else{
			$this->mem->delete($key);
		}

		//sleep(4);
		if($result = $this->mem->add($key, null)){
			$data = call_user_func_array(array($this, $relFunc), $args);
			if(!empty($data)){
				$this->mem->set($key, $data, $cache_time_params);
			}
		} else {
			for($i=0; $i<20; $i++) { //4秒没有反应，就出白页吧，系统貌似已经不行了
				sleep(0.2);
				$this->logs->w($key.'_'.$i);
				$data = $this->mem->get($key);
				if ($data !== false){
					break;
				}
			}
		}
		return $data;
	}




	/**
	 *	@func 析构函数
	 */
	public function __destruct(){
		//$this->mem = null;
	}


}

?>
