<?php
/**
 *	采集任务
 */

class RobotController extends BaseController{ //RobotController,Yaf_Controller_Abstract

	public function indexAction(){
		echo "robot baidu\n";
	}

	//* * * * * /usr/local/php/bin/php /home/wwwroot/mdread/index.php request_uri="/robot/baiduKw"
	//php index.php request_uri="/robot/baiduKw"
	public function baiduKwAction(){
		$baidu = new baiduModel();
		$list = $baidu->get(2);
		foreach ($list as $key => $value) {
			$url = "http://www.baidu.com/s?&wd=".urlencode($value['keyword']);
			$res = $this->openUrl($url);
			var_dump($res);
			if(!$res){
				echo "资源获取失败<br>";
				continue;
			}

			//var_dump($res);
			$match = "~div class=\"c-gap-top-small\"><a target=\"_blank\" title=\"(.*)\"~iUs";
			preg_match_all($match, $res,$_content);
			//var_dump($_content);
			$_list = $_content[1];
			foreach ($_list as $_key => $_value) {
				echo($_value."<br/>");
				$baidu->add($_value, 1);
			}
		}
		echo "success\n";
	}


}
?>
