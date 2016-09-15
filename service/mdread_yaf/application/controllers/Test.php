<?php

//测试
class TestController extends BaseController{


	public function indexAction(){
		$info['test'] = 'oh,you known';
		echo json_encode($info);
	}

	public function ruleAction(){

		$obj = new ruleModel();

		$test_data = $obj->get(1);

		//var_dump($test_data);
		$_test_data = $test_data['rule_content'];

		//var_dump($_test_data);

		//搜索测试
		$keyword = "凡人";

		$url = str_replace('{keyword}', $keyword, $_test_data['soso']['url']);
		$test_d = openUrl($url);

		//var_dump($test_d);

		preg_match_all($_test_data['soso']['regx'], $test_d , $_content);
		if(empty($_content)){
			var_dump($_content);
		} else {
			echo $test_data['name'], ' test soso ', " ok!!!<br>";
		}

		//书籍信息测试
		$test_url = $test_data['test_addr'];
		echo $test_url,"<br/>";
		$url_data = openUrl($test_url);

		foreach ($_test_data['instro'] as $name => $regx) {
			$ret = preg_match_all($regx, $url_data , $_content);

			if(!$ret){
				echo $name , ' regx test fail<br>';
				echo $regx,"<br>";
			} else {
				echo($this->charset($_content[1][0]));
				echo "\t",$name , "\t",' regx test ok<br>';
			}
		}

		//书籍列表测试
		$book_list_data = $_test_data['chapter'];
		$book_list_regx = $book_list_data['book_chapter'];
		$ret = preg_match_all($book_list_regx, $url_data , $_content);
		if($ret){
			foreach ($_content[1] as $_ck=> $_cv) {
				echo $_cv, " ", $this->charset( $_content[2][$_ck] ) ,"<br/>";
			}
			echo "书籍列表 -- ok<br/>";
		} else {

			echo "书籍列表 -- fail<br/>";
		}

		//书籍内容测试
		$book_list_type = $book_list_data['book_chapter'];
		if($book_list_type == 0){

			$content_url = $test_url.$_content[1][0];
			echo $content_url, "<br/>";

			$_content_data = openUrl($content_url);

			$_content = $_test_data['content'];
			$_content_regx = $_content['content'];

			//var_dump($_content_regx);
			$ret = preg_match_all($_content_regx, $_content_data , $_data_match);
			if($ret){
				echo $this->charset($_data_match[1][0]);
				echo "书籍内容测试 -- regx ok<br/>";
			} else {
				echo "书籍内容测试 -- regx fail<br/>";
			}

		} else {
			echo "书籍内容测试 -- fail<br/>";
		}	
	}

	public function updateRuleAction(){

		$id = "2";
		$json = file_get_contents(APP_PATH.'rules/'.$id.'.json');
		//$json = json_decode($json, true);
		//$json_data = json_encode($json);
		$obj = new ruleModel();
		$obj->update($id, $json);
		echo($json);
	}
}
?>
