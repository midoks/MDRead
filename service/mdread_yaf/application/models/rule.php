<?php 
class ruleModel extends Model{

	//获取文件数据
	public function getFileData($id){
		$json = file_get_contents(APP_PATH.'rules/'.$id.'.json');
		$json = json_decode($json, true);


		$json['content']['content'] = str_replace("\\\\",'\\', $json['content']['content']);
		return $json;
	}

	public function get($id){
		$list = $this->db->searchAll('rules', [], " id='{$id}' ", 1, []);
		$data = $list[0];
		$data['rule_content'] = json_decode($data['rule_content'], true);
		return $data;
	}

	public function getIdList(){
		$list = $this->db->searchAll('rules', [], '', 100, []);
		return $list;
	}

	public function getRandSource(){
		$list 	= $this->getIdList();
		$s 		= mt_rand(0,count($list)-1);
		$ret 	= $list[$s];
		$ret['rule_content'] = json_decode($ret['rule_content'], true);
		return $ret;
	}

	public function update($id, $json){
		$_info = json_decode($json, true);
		$sql = "select * from ".$this->db->table('rules')." where id='{$id}'";
		$data = $this->db->get_one($sql);
		if(!$data){
			$ret = $this->add($id, $_info['name'], $_info['web_site'], $_info['test_addr'], $json);
		} else {
			$sql = "update ".$this->db->table('rules')." set rule_content='{$json}' where id='{$id}'";
			$ret = $this->db->query($sql);
		}
		return $ret;
	}

	public function add($id, $web_name, $web_site, $test_addr, $rule_content, $status = 1){
		$sql = "insert into ".$this->db->table('rules')." values('{$id}','{$web_name}', '{$web_site}', '{$test_addr}', '{$rule_content}', '{$status}')";
		$ret = $this->db->query($sql);
		return $ret;
	}

}

?>