<?php 
/**
 *	@author midoks
 *  封装mongodb 操作类
 *  
 */

class mongoSvc{

	public $linkID = NULL;
	public $db 	   = NULL;
	public $collection = NULL;

	public $config = array();

	public static $_instance 		= NULL;

	public static function instance(){
		if (!self::$_instance){
			self::$_instance = new mongoSvc();
		}
		return self::$_instance;
	}

	public function register($config){
		$this->config = $config;
		$this->connect($config);
	}

	public function connect($config){
		$this->linkID 	= new MongoClient($config['conn']);
		$this->db 		= $this->linkID->$config['db'];
	}

	public function add($collection, array $data){
		$this->collection = $this->db->createCollection($collection);
		return $this->collection->insert($data);
	}


	public function find($collection, array $query){
		$this->collection = $this->db->createCollection($collection);
		$cursor = $this->collection->find($query);
		$list  = [];
		foreach ($cursor as $document) {
			$list[] = $document;
		}
		return $list;
	}


}

?>