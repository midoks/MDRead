<?php 
/**
 * @author midoks
 * 封住mysql操作类
 */

class mySqlDb{

	public $masterDbLinkID 	= NULL;
	public $slaveDbLinkID 	= NULL;

	public $config 			= array();

	public static $_instance 		= NULL;

	public static function instance(){
		if (!self::$_instance){
			self::$_instance = new mySqlDb();
		}
		return self::$_instance;
	}

    /**
  	 *	[
  	 *		'master' =>
  	 *		［[
	 *			'db_host' 			=> '121.42.151.169',
	 *			'db_name' 			=> '...',
	 *			'db_user' 			=> '...',
	 *			'db_pwd'  			=> '...',
	 *			'db_charset' 		=> 'utf8',
	 *			'db_table_prefix' 	=> 'dd_',
	 *		]],
	 *		'slave' => 
	 *		[[
	 *			'db_host' 			=> '121.42.151.169',
	 *			'db_name' 			=> '...',
	 *			'db_user' 			=> '...',
	 *			'db_pwd'  			=> '...',
	 * 			'db_charset' 		=> 'utf8',
	 *			'db_table_prefix' 	=> 'dd_',
	 *		]]
	 *	]
	 */
	public function register($config){
		$this->config = $config;

		if(!$this->masterDbLinkID){
			if(isset($this->config['master']) && !empty($this->config['master'])){
				$r = mt_rand(0, count($this->config['master']) - 1);
				$config = $this->config['master'][$r];
				$this->masterDbLinkID = $this->connect($config);
				$this->linkID = $this->masterDbLinkID;
			}
		}

		if(!$this->slaveDbLinkID){

			if(isset($this->config['slave']) && !empty($this->config['slave'])){
				$r = mt_rand(0, count($this->config['slave']) - 1);
				$config = $this->config['slave'][$r];
				$this->slaveDbLinkID = $this->connect($config);
			}

			if(isset($this->config['master']) && !empty($this->config['master'])){
				$r = mt_rand(0, count($this->config['master']) - 1);
				$config = $this->config['master'][$r];
				$this->slaveDbLinkID = $this->connect($config);
			}
		}
	}


	/**
	 *	数据库链接
	 *	
	 */
	private function connect($config){
		$c = $config;
		try{

			$dbh = new PDO('mysql:host='.$c['db_host'].';dbname='.$c['db_name'],
						   	$c['db_user'], 
						  	$c['db_pwd'],
							array(	
								PDO::ATTR_PERSISTENT	=>	false, 	//是否支持长链接
								PDO::ATTR_AUTOCOMMIT	=>	true ) //是否自动提交
							);

			//产生致命错误,PDOException
			$dbh->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);
			$dbh->exec('set names '.$c['db_charset']);

			return $dbh;
		}catch(PDOException $e){
			echo '数据库连接失败: '.$e->getMessage();exit;
		}
	}

	/**
	 *  @func 
	 *  
	 */
	public function _query($sql, $bind = array(),$mode = PDO::FETCH_ASSOC){

		$trim_sql = trim($sql);

		//查询数据
		if(preg_match( '/^\s*(select|show|describe)/i', $trim_sql)){

			$rows = $this->slaveDbLinkID->query($sql, $mode);
			return $rows->fetchAll();

		}else if(preg_match('/^\s*(insert|delete|update|replace)/i', $trim_sql)){
			//添加数据 更新数据 删除数据 替换数据
			//return $this->exec($trim_sql, $bind);

			$stmt = $this->masterDbLinkID->prepare($sql);
			if(!$stmt){
				print_r($this->masterDbLinkID->errorInfo());
			}
			$ret = $stmt->execute($bind);
			if(preg_match('/^\s*(insert)/i', $sql)){
				$last_id = $this->insert_last_id();
				return $last_id;
			}else if(preg_match('/^\s*(update|delete|replace)/i', $sql)){
				return $stmt->rowCount();
			}
		}
		return false;
	}

	public function query($sql, $bind = array(),$mode = PDO::FETCH_ASSOC){
		$start_time =  microtime(true);
		$result =  $this->_query($sql, $bind = array(),$mode = PDO::FETCH_ASSOC);
		$this->debug($sql);
		$this->debug( "\nuse time:".(microtime(true) - $start_time) );
		return $result;
	}


	public function debug($content, $fileName = 'content'){
		$filename = APP_PATH.'logs/'.$fileName.'-'.date('Y-m-d').'.txt';
		if(!file_exists($filename)){
			@touch($filename);
			@chmod($filename,0777);//权限改为777
		}
		$fp = fopen($filename, "a");
		flock($fp,	LOCK_EX) ;
		fwrite($fp, $content."\r\n");
		flock($fp, 	LOCK_UN);
		fclose($fp);
	}
	
	//获取查询结果数据
	public function get_result($sql,$mode = PDO::FETCH_ASSOC){
		$result = $this->query($sql, [], $mode);
		return $result;
	}

	//获取一条结果数据
	public function get_one($sql, $mode = PDO::FETCH_ASSOC){
		$result = $this->query($sql);
		if(!empty($result)){
			return $result[0];
		} else {
			return false;
		}
	}

	/**
	 * 查询
	 * @param array $binds 数据绑定['a'=1,'b'=2]
	 * @param string $where 查询条件 a=:a and b=:b
	 * @param int $limit 默认值100 ;0表示全部  ;1，10表示偏移量 
	 * @param array $feild 需要输出的字段 ['id','name']
	 * @param string $order 排序 'id desc'
	 * @param string $group 分组 ' city'
	 * @param string $having having
	 */
	public function searchAll($table, array $binds, $where,$limit=100,array $feild=[],$order='',$group='',$having=''){
		$table = $this->table($table);

		$feildstr = '*';
		if(!empty($feild)) {
			$feildstr = implode(',', $feild);
		}
		$sql = "select $feildstr from {$table} ";
		if(!empty($where)) {
			$sql.="where $where ";
		}
		if(!empty($group)) {
			$sql .= "group by $group ";
			if(!empty($having)) {
				$sql .= "having $having  ";
			}
		}
		if(!empty($order)) {
			$sql .= "order by $order ";
		}
		if(strstr($limit,',')) {
			$sql .= "limit $limit";
		}elseif($limit!=0) {
			$sql.="limit $limit";
		}
		//var_dump($sql);
		return $this->query($sql, $binds);
	}


	//插入数据
	public function insertGetId($table, array $data){
		$table = $this->table($table);

		$sql = "insert into `".$table.'`';

		$insert_k = '(';
		$insert_v = '(';
		foreach ($data as $key => $value) {
			$insert_k .= "`".$key."`,";
			$insert_v .= "'".$value."',";
		}

		$insert_k = trim($insert_k, ',').')';
		$insert_v = trim($insert_v, ',').')';

		$sql .= $insert_k.' values '.$insert_v;
		return $this->query($sql);
	}

	//批量插入
	public function insertPGetId($table, array $data){
		
		$table = $this->table($table);
		$sql = "insert into `".$table.'`';

		$insert_k = '(';
		foreach ($data[0] as $key => $value) {
			$insert_k .= "`".$key."`,";
		}
		$insert_k = trim($insert_k, ',').')';


		$insert_v = '';
		foreach ($data as $key => $value) {
			$insert_v1 = '(';
			foreach ($value as $k1 => $v1) {
				$insert_v1 .= "'".$v1."',";
			}
			$insert_v1 = trim($insert_v1, ',').')';

			$insert_v .= $insert_v1.',';
		}
		$insert_v = trim($insert_v, ',');

		$sql .= $insert_k.' values '.$insert_v;

		return $this->query($sql);
	}

	public function delete($table, $where){
		$table = $this->table($table);
		$sql = 'delete from '.$table.' where '.$where;
		return $this->query($sql);
	}

	public function update($table, array $data){
		$table = $this->table($table);
		$sql = "update ".$table.' set ';
		

	}

	public function select($table, $where){

	}

	/**
	 * 	加入表前缀
	 * 	@param 	string $table 表名
	 * 	@param 	string $prefix 表前缀
	 * 	@ret 	stirng
	 */
	public function table($table, $prefix=''){
		if(!empty($prefix)){
			return $prefix.$table;
		}else{
			return $this->config['master'][0]['db_table_prefix'].$table;
		}
	}

	/**
	 * 事务相关的函数
	 * 默认的MyISAM 不支持事务
	 * InnoDB 支持事务
	 */

	//开始事务
	public function begin(){
		if(!$this->masterDbLinkID) return false;
		return $this->masterDbLinkID->beginTransaction();
	}

	//事务回滚
	public function rollback(){
		if(!$this->masterDbLinkID) return false;
		return $this->masterDbLinkID->rollBack();
	}

	//事务确认
	public function commit(){
		if(!$this->masterDbLinkID) return false;
		return $this->masterDbLinkID->commit();
	}


	/**
	 *	对不支持事务的MyISAM引擎数据库使用锁表
	 */

	/**
	 * 	@func 	锁表
	 *	@param 	$table	表名
	 *	@param	$rw 	[READ|WRITE]
	 *	@ret 	void
	 */
	public function lock($table, $rw = 'WRITE'){
		return $this->masterDbLinkID->query("LOCK TABLES `{$table}` {$rw}");
	}

	/**
	 * 	@func 	解锁
	 * 	@param	$table 表名
	 * 	@ret 	void
	 */
	public function unlock(){
		return $this->masterDbLinkID->query('UNLOCK TABLES');
	}
	

	//最后插入的ID
	private function insert_last_id(){
		 return $this->masterDbLinkID->lastInsertId();
	}

	//字符串转义
	public function quote($string, $parameter_type = PDO::PARAM_STR){
		return $this->masterDbLinkID->quote($string, $parameter_type);
	}

	/**
	 *	@func 析构函数
	 */
	public function __destruct(){
		$this->masterDbLinkID 	= null;
		$this->slaveDbLinkID 	= null;
	}
}
?>