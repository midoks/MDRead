<?php
/**
 * 
 */

class sosoModel extends Model{

	/**
	 * 添加搜索记录
	 * @param $keyword 关键字
	 */
	public function add($keyword){
		$time = time();

		$select_sql = "select * from ".$this->db->table('books_soso') ." where keyword='{$keyword}' limit 1";
		$data = $this->db->get_one($select_sql);

		if($data){
			$update_sql = "update ".$this->db->table('books_soso')." set num=num+1,update_time='{$time}'  where keyword='{$keyword}'";

			// $list = array()
			// $ret = $this->db->update('books_soso', $list, $where);

			$ret = $this->db->query($update_sql);
		} else {
			$sql = "insert into ".$this->db->table('books_soso') ." values(null,'{$keyword}', 1, 0, '{$time}', '{$time}')";
			$ret = $this->db->query($sql);
		}

		return $ret;
	}

	public function delete($id){

	}





}

?>