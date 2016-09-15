<?php
/**
 * 
 */
class baiduModel extends Model{


	public function get($num){
		$sql = "select * from ".$this->table('baidu_keyword')." where `status`=1 order by id desc limit {$num}";
		$result = $this->db->get_result($sql);
		return $result;
	}

	public function isExists($name){
		$sql = "select * from ".$this->table('baidu_keyword')." where keyword='{$name}'";
		$result = $this->db->get_one($sql);
		if(!$result){
			return false;
		}
		return true;
	}

	public function add($kw, $status=1){
		$isOk = $this->isExists($kw);
		if($isOk){
			return true;
		}

		$time = time();
		$sql = "insert into ".$this->table('baidu_keyword')." values(null, '{$kw}', '{$status}','{$time}')";
		$ret = $this->db->exec($sql);
		return $ret;
	}

}

?>