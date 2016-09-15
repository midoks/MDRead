<?php


class cronModel extends Model{

	
	public function addBook($source_id, $source_url){
		$time = time();
		$sql = "insert into ".$this->db->table('cron_book')." values(null, '{$source_id}', '{$source_url}','{$time}')";
		$ret = $this->db->query($sql);
		return $ret;
	}

	public function addPBook(array $data){
		$ret = $this->db->insertPGetId('cron_book', $data);
		return $ret;
	}


	public function deleteBook($id){
		$ret = $this->db->delete('cron_book', "id='{$id}'");
		return $ret;
	}

	public function getBookByIdAndUrl($source_id, $source_url){
		$sql = "select * from ".$this->table('cron_book'). " where source_id='{$source_id}' and source_url='{$source_url}'";
	}

	//获取采集小说地址
	public function getBook($num = 1){
		$sql = "select * from ".$this->table('cron_book'). " order by id limit {$num}";
		return $this->db->get_result($sql);
	}


	public function getW(){
		$sql = "select * from ".$this->table('cron_w'). " limit 1";
		return $this->db->get_one($sql);
	}

	public function addW($word){
		$sql = "select * from ".$this->table('cron_w'). " where w='{$word}'";
		$data = $this->db->get_one($sql);

		if($data){
			return false;
		}

		$insert_data = ['w'=>$word,'add_time'=>time()];
		return $this->db->insertGetId('cron_w', $insert_data);
	}

	public function delW($id){
		return $this->db->delete('cron_w', "id='{$id}'");
	}






}

?>