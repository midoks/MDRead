<?php
/**
 *	采集任务
 */

class RobotController extends BaseController{ //RobotController,Yaf_Controller_Abstract

	public function indexAction(){
		echo "robot\n";
	}

	//每小说检查小说更新
	//根据关键字,搜索书籍信息

	//* * * * * /usr/local/php/bin/php /home/wwwroot/mdread/index.php request_uri="/robot/soso"
	//php index.php request_uri="/robot/soso"
	public function sosoAction(){

		$rule = new ruleModel();
		$cron = new cronModel();
		$rule_data = $rule->getRandSource();
		$source_id = $rule_data['id'];

		$_rule = $rule_data['rule_content'];

		//搜索测试
		$_getW = $cron->getW();
		if(!$_getW){
			die('缺少关键词!');
		}
		$_keyword = $_getW['w'];
		$keyword = urlencode($_keyword);

		$url = str_replace('{keyword}', $keyword, $_rule['soso']['url']);
		$soso_data = openUrl($url);

		$match_status = preg_match_all($_rule['soso']['regx'], $soso_data , $_content);
		if($match_status){

			$list = array();
			$insert_time = time();
			foreach ($_content[0] as $key => $value) {
				$tmp = array();

				$tmp['source_id'] 	= $source_id;
				$tmp['source_url'] 	= $_content[1][$key];
				$tmp['source_umd5']	= md5($_content[1][$key]);
				$tmp['create_time']	= $insert_time;

				$list[] = $tmp;
			}
			
			$ret = $cron->addPBook($list);
			if($ret){
				echo "{$_rule['name']} {$_keyword} task ok!<br>";
			} else {
				echo "{$_rule['name']} {$_keyword} task fail!<br>";
			}
			$cron->delW($_getW['id']);
		} else {
			$cron->delW($_getW['id']);
			echo "resources get fail\n";
		}
	}

	//采集书籍
	//* * * * * /usr/local/php/bin/php /home/wwwroot/mdread/index.php request_uri="/robot/cronBook"
	//php index.php request_uri="/robot/cronBook"
	public function cronBookAction(){

		$rule = new ruleModel();
		$cron = new cronModel();
		$book = new bookModel();

		$list = $cron->getBook(1);

		if(empty($list)){
			die('没有计划任务!!!');
		}

		foreach ($list as $k => $v) {
			
			$cronRule = $rule->get($v['source_id']);
			$cronRuleContent = $cronRule['rule_content'];
			$res = openUrl($v['source_url']);
			if($res){
				//书籍基本信息
				$bookInfo = array();
				foreach ($cronRuleContent['instro'] as $name => $regx) {
					$ret = preg_match_all($regx, $res, $matchValue);
					//var_dump($regx, $matchValue);
					if($ret){
						$bookInfo[$name] = trim($this->charset($matchValue[1][0]));
					} else {
						$bookInfo[$name] = '';
					}
				}

				if (empty($bookInfo['book_name']) || empty($bookInfo['book_author'])){
					$cron->deleteBook($v['id']);
					exit(json_encode($bookInfo));
				}

				//书籍列表信息
				$bookList = $cronRuleContent['chapter'];
				$bookListRegx = $bookList['book_chapter'];
				$ret = preg_match_all($bookListRegx, $res , $_content);
				$bookListInfo = array();
				if($ret){
					foreach ($_content[1] as $_ck=> $_cv) {
						$info = array(
							'source_url' 	=> $v['source_url'].$_cv,
							'chapter_name'	=> trim($this->charset( $_content[2][$_ck] )),
						);
						$bookListInfo[] = $info;
					}
				} 

				$bookInfo['source_url'] = $v['source_url'];
				$bookInfo['source_id'] 	= $v['source_id'];

				//var_dump($bookInfo);
				//var_dump($bookListInfo);
				//exit;
				$ret = $book->addBookInfoAndChapter($bookInfo, $bookListInfo);
				$cron->deleteBook($v['id']);
				echo "{$v['id']},{$v['source_url']},success\r\n";
			} else {
				$cron->deleteBook($v['id']);
				echo "{$v['id']},{$v['source_url']},resources get fail\r\n";
			}
		}
	}
}
?>
