<?php

/**
 * @author midoks
 * @func   书籍相关
 */

class BookController extends BaseController{

	public function searchAction(){

		//return $this->retJson($_POST);

		$word = $this->request('w', '');
		if(!empty($word)){
			$word = urldecode($word);

			if(!preg_match("/^[\x{4e00}-\x{9fa5}A-Za-z0-9]+$/u", $word, $match)){
				return $this->retJson(array(
					'ret_code' 	=> -1,
					'ret_msg'	=> '不能含有特殊关键字',
				));
			}

			$book = new bookModel();
			$list = $book->search($word);

			$soso = new sosoModel();
			$soso->add($word);

			if(empty($list)){

				$cron = new cronModel();
				$cron->addW($word);

				return $this->retJson(array(
					'ret_code' 	=> -1,
					'ret_msg'	=> '没有数据',
				));
			}
			return $this->retJson($list);
		} else {	
			return $this->retJson(array(
				'ret_code' 	=> -1,
				'ret_msg' 	=> '参数不完整!!!',
			));
		}
	}

	public function authorListAction(){
		$book_id = $this->request('book_id', '');
		$author_name = $this->request('book_author', '');
		$author_name = urldecode($author_name);

		if(!empty($author_name) && is_numeric($book_id) ){
			$book = new bookModel();
			$list = $book->authorList($author_name, $book_id);
			return $this->retJson($list);
		} else {
			return $this->retJson(array(
				'ret_code' 	=> -1,
				'ret_msg' 	=> '参数不完整!!!',
			));
		}
	}

	/**
	 * 根据book_i获取列表
	 */
	public function listAction(){

		$book_id = $this->request('book_id', '');
		$source_id = $this->request('source_id', '');
		//$book_id = $this->getRequest()->getParam("book_id", "");
		//$source_id = $this->getRequest()->getParam("source_id", "");
		
		if(is_numeric($book_id) && is_numeric($source_id) ){
			$book = new bookModel();
			$list = $book->bookList($book_id, $source_id);
			return $this->retJson($list);
		} else {
			return $this->retJson(array(
				'ret_code' 	=> -1,
				'ret_msg' 	=> '参数不完整!!!',
			));
		}
	}

	public function contentReplace($content){
		$content = str_replace('&nbsp;', ' ', $content);
		$content = str_replace('<br>', '', $content);
		$content = str_replace('<br/>', '', $content);
		$content = str_replace('<br />', '', $content);

		return $content;
	}

	//获取小说内容
	public function contentAction(){

		$chapter_id = $this->request('chapter_id', '');
		$source_id = $this->request('source_id', '');

		// $chapter_id = $this->getRequest()->getParam("chapter_id", "");
		// $source_id  = $this->getRequest()->getParam("source_id", "");
		if(is_numeric($chapter_id)){

			$book = new bookModel();
			$rule = new ruleModel();

			$_data = $book->getChapterContent(['chapter_id'=> intval($chapter_id)]);
			if(!empty($_data)){
				$content = $_data[0]['content'];
				
				$content = $this->contentReplace($content);

				$info['chapter_id'] = $chapter_id;
				$info['content']	= $content;
				return $this->retJson($info);
			}

			
			$info = $book->content($chapter_id);
			$rule_content = $rule->get($info['source_id']);

			$result_res = openUrl($info['source_url']);
			//var_dump($rule_content);
			$match = $rule_content['rule_content']['content']['content'];
			preg_match_all($match, $result_res, $_data_match);

			//var_dump($_data_match[1][0]);

			$content = $this->charset($_data_match[1][0]);

			$time = time();
			$add_content = [
				'chapter_id' => intval($chapter_id),
				'book_id' => intval($info['book_id']),
				'source_id' => intval($info['source_id']),
				'add_time'=> $time,
				'content' => $content];
			$book->saveChapterContent($add_content);

			//$content = base64_encode($content);
			$content = $this->contentReplace($content);

			$info['content'] = $content;
			
			return $this->retJson($info);
		} else {
			return $this->retJson(array(
				'ret_code' 	=> -1,
				'ret_msg' 	=> '参数不完整!!!',
			));
		}
	}
	
	public function sourceAction(){
		$book_id = $this->getRequest()->getParam("book_id", "");
		if(is_numeric($book_id)){
			$book = new bookModel();

			$info = $book->bookSource($book_id);

			return $this->retJson($info);
		} else {
			return $this->retJson(array(
				'ret_code' 	=> -1,
				'ret_msg' 	=> '参数不完整!!!',
			));
		}
	}
	
	//小说推荐
	public function recommendAction(){
		$book = new bookModel();
		$list = $book->recommendWC(10);
		return $this->retJson($list);
	}

	//随机小说
	public function randAction(){
		$book = new bookModel();
		//sleep(2);
		$list = $book->randBook2WCL(2);
		// var_dump($list);
		// exit;
		return $this->retJson($list);
	}


	//各种榜单
	public function bang_listAction(){

		$book = new bookModel();
		$_list = $book->randBookWC(60*60);

		$_list_rand = $book->randBook2WC(3);

		$list[] = ['title' => '-- 日❤️榜单 --','data'  => $_list];
		$list[] = ['title' => '-- 周榜单 --','data'  => $_list_rand];
		$list[] = ['title' => '月榜单','data'  => $_list];
		$list[] = ['title' => '最新榜单','data'=> $_list];
		$list[] = ['title' => '-- 随机榜 --','data'=> $_list];
		$list[] = ['title' => '-- 冷门榜 --','data'=> $_list];

		return $this->retJson($list);
	}

}
?>
