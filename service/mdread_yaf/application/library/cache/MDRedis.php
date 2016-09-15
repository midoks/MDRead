<?php
/**
 *	@func 基本管理模型
 */
class MDRedis{

	
	protected 	$link = null;

	/**
	 *	@func 构造函数
	 */
	public function __construct(){
	
		if(!$this->link){
			$this->link = new Redis();
			$this->link->connect('127.0.0.1', 6379);
		}
	}

	public function add(){


	}


	/**
	 *	@func 析构函数
	 */
	public function __destruct(){
		$this->linkID = null;
	}

}

?>