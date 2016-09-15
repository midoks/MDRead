<?php

class bookModel extends Model{

	public function getUrl(){

		if($_SERVER['SERVER_ADDR'] == '127.0.0.1'){
			return 'http://md.cc/static/test/';
		}
		return 'http://121.42.151.169/static/images/';
	}

	/**
	 * 搜索书籍
	 * @param $keyword 关键字
	 * @return array
	 */
	public function search($keyword){
		$where  = " where bb.book_name like '%{$keyword}%' || ";
		//$where .= " bb.book_desc like '%{$keyword}%' || ";
		$where .= " bb.book_author like '%{$keyword}%'";
		

		$sql = "select bb.id as book_id, bs.source_id as source_id, bb.book_name as book_name,".// 
				"bb.book_desc as book_desc,bb.book_image as book_image,bb.book_author as book_author,".
				"bb.book_type as book_type, bb.book_status as book_status from ".$this->table('books') 
				." bb left join ".$this->table('books_source')." bs on bb.id=bs.book_id  {$where} group by bb.book_name limit 10";
		//var_dump($sql);
		//exit;
		$data = $this->db->get_result($sql);

		if(!empty($data)){
			foreach ($data as &$value) {
				$value['book_image'] = $this->getUrl().$value['book_image'];
			}
		}

		return $data;
	}


	/**
	 *	作者作品列表
	 *  @param $author 	作者名
	 *  @param $book_id	需要过滤的$book_id
	 */
	public function authorList($author, $book_id){

		$sql = "select t1.id as book_id, t1.book_name,t1.book_desc,t1.book_image,t1.book_author from ".
				$this->table('books')." t1 where book_author = '{$author}'";
		//var_dump($sql);
		$data = $this->db->get_result($sql);
		$_data = array();
		if(!empty($data)){
			foreach ($data as &$value) {
				$value['book_image']= $this->getUrl().$value['book_image'];
				$value['source_id'] = $this->getBookSourceIDWC(60*60,$value['book_id']);
				if($book_id != $value['book_id']){
					$_data[] = $value;
				}
			}
		}
		return $_data;
	}


	//推荐小说
	public function recommend(){

		$sql = "select bb.id as book_id, bs.source_id as source_id, bb.book_name as book_name,".// 
				"bb.book_desc as book_desc,bb.book_image as book_image,bb.book_author as book_author,".
				"bb.book_type as book_type, bb.book_status as book_status from ".$this->table('books').
				" bb left join ".$this->table('books_source')." bs on bb.id=bs.book_id group by bb.book_name order by bb.id desc limit 8";
		$list = $this->db->get_result($sql);

		if(!empty($list)){
			foreach ($list as &$value) {
				$value['book_image'] = $this->getUrl().$value['book_image'];
			}
		}
		return $list;
	}

	//随机小说
	public function randBook(){

		$sql = "select bb.id as book_id, bs.source_id as source_id, bb.book_name as book_name,".// 
				"bb.book_desc as book_desc,bb.book_image as book_image,bb.book_author as book_author,".
				"bb.book_type as book_type, bb.book_status as book_status from ".$this->table('books').
				" bb left join ".$this->table('books_source')." bs on bb.id=bs.book_id group by bb.book_name order by RAND() limit 4";
		$list = $this->db->get_result($sql);

		if(!empty($list)){
			foreach ($list as &$value) {
				$value['book_image'] = $this->getUrl().$value['book_image'];
			}
		}
		return $list;
	}

	public function getBookSourceID($book_id){
		$sql = "select * from ".$this->table('books_source')." where book_id='{$book_id}' limit 1";
		$data =$this->db->get_one($sql);
		//var_dump($data);
		return $data['source_id'];
		//return '1';
	}

	//随机小说
	public function randBook2(){
		// $sql = "select bb.id as book_id, bs.source_id as source_id, bb.book_name as book_name,".// 
		// 		"bb.book_desc as book_desc,bb.book_image as book_image,bb.book_author as book_author,".
		// 		"bb.book_type as book_type, bb.book_status as book_status from ".$this->table('books').
		// 		" bb left join ".$this->table('books_source')." bs on bb.id=bs.book_id group by bb.book_name order by RAND() limit 4";
		// $list = $this->db->get_result($sql);

		$sql = "SELECT t1.id as book_id, t1.book_name,t1.book_desc,t1.book_image,t1.book_author,".
		"t1.book_type,t1.book_status  FROM `".$this->table('books')
		."` AS t1 JOIN (SELECT ROUND(RAND() * ((SELECT MAX(id) FROM `".$this->table('books')
		."`)-(SELECT MIN(id) FROM `".$this->table('books')
		."`))+(SELECT MIN(id) FROM `".$this->table('books')."`)) AS id) AS t2 WHERE t1.id >= t2.id ORDER BY t1.id LIMIT 1";

		$list = array();
		for($i = 0; $i<4; $i++){
			$list[] = $this->db->get_one($sql);
		}

		if(!empty($list)){
			foreach ($list as &$value) {
				$value['book_image'] = $this->getUrl().$value['book_image'];
				$value['source_id'] = $this->getBookSourceIDWC(60*60,$value['book_id']);
			}
		}
		return $list;
	}


	public function bookList($book_id, $source_id){
		$list = $this->db->searchAll('books_chapter', [], 
				"book_id='{$book_id}' and source_id='{$source_id}'",
				2000,['id as chapter_id','chapter_name','source_id','sort'], 'sort asc');
		return $list;
	}

	/**
 	 * 获取文章内容信息
 	 * @param $chapter_id 文章内容ID
	 */
	public function content($chapter_id){
		$sql = "select * from ".$this->table('books_chapter')." where id='{$chapter_id}'";
		$result = $this->db->get_one($sql);
		return $result;
	}
	
	/**
	 * 获取小说有多少源
	 */
	public function bookSource($book_id){
		$sql = "select bs.source_id as source_id, bs.book_id as book_id, br.web_site as source_url from "
			.$this->table('rules') ." br inner join ".$this->table('books_source')." bs on bs.source_id=br.id and bs.book_id='{$book_id}' limit 20";

		$list = $this->db->get_result($sql);
		return $list;
	}

	public function saveChapterContent(array $data){
		return $this->mongo->add('list_test', $data);
	}

	public function getChapterContent(array $data){
		return $this->mongo->find('list_test', $data);
	}

	/**
	 * 规则搜索
	 * @param $keyword 关键字
	 */
	public function searchRule($keyword){
		$sql = "select id,rule_soso from ".$this->table('rules') ." limit 1";
		$data = $this->db->get_one($sql);
		//var_dump($data);

		$rule = explode('|', $data['rule_soso']);
		// var_dump(base64_encode($rule[0]));
		// var_dump(base64_encode($rule[1]));

		$url = str_replace('{keyword}', $keyword, $rule[0]);
		$res = openUrl($url);
		$regx_ret = preg_match_all( $rule[1], $res , $_content );
		if( $regx_ret ){

			$books_list = $_content[1];
			
			
			foreach ($books_list as $k => $v ) {
				$this->getBookInfoBySource($data['id'], $v);
				exit;
			}


		} else {
			$_content = array();
		}
		return $_content;
	}

	public function getBookInfoBySource($source_id, $books_url){
		$sql = "select * from ".$this->table('rules') ." where id='{$source_id}'";
		$data = $this->db->get_one($sql);
		
		


		$res = openUrl($books_url);

		var_dump($res);
		$regx_ret = preg_match_all('~<meta property="og:novel:category" content="(.*)"/>~iUs', $res , $_content);

		var_dump($regx_ret, $_content);

		// $regx_ret = preg_match_all('~<div id="fmimg"><img alt=".*" src="(.*)" width="120" height="150" /><span class="b"></span></div>~is', $res , $_content);

		// var_dump($regx_ret, $_content);

		// $regx_ret = preg_match_all('~<h1>(.*)</h1>~is', $res , $_content);
		// var_dump($regx_ret, $_content);

		if ($res){



		} else{

			echo $source_id, $books_url,'fail';
		}
		//var_dump($source_id, $books_url);
	}


	/**
	 *	通过md5获取书籍
	 *	@param $md5 md5($book_info['book_name'].$book_info['book_author'])
	 */
	public function getBookByMd5($md5){
		$sql = "select id from ".$this->table('books')." where book_md5='{$md5}'";
		return $this->db->get_one($sql);
	}

	/**
	 * 添加书籍,如果存在返回当前id
	 * @param $book_info 书籍信息
	 */
	public function addBook($book_info){
		$book_md5 = md5($book_info['book_name'].$book_info['book_author']);
		if($book_ret = $this->getBookByMd5($book_md5)){
			return $book_ret['id'];
		}
		$time = time();

		$book_image = download_image($book_info['book_image']);
		if(!$book_image){
			$book_image = $book_info['book_image'];
		}

		$ret = $this->db->insertGetId('books',array(
				'book_name' 	=> $book_info['book_name'],
				'book_desc' 	=> $book_info['book_desc'],
				'book_image' 	=> $book_image,
				'book_author' 	=> $book_info['book_author'],
				'book_type' 	=> $book_info['book_type'],
				'book_status' 	=> $book_info['book_status'],
				'book_md5' 		=> $book_md5,
				'update_time'	=> $time,
				'create_time'	=> $time
			));

		return $ret;
	}

	/**
	 *	通过$source_url获取书籍源数据
	 *	@param $source_url 源地址
	 */
	public function getBookSourceBySurl($source_url){
		$sql = "select id from ".$this->table('books_source')." where source_url='{$source_url}'";
		return $this->db->get_one($sql);
	}


	/**
	 * 添加书籍源
	 */
	public function addBookSource($book_id, $source_id, $source_url){
		$book_source = $this->getBookSourceBySurl($source_url);
		if($book_source){
			return $book_source['id'];
		}
		$time = time();
		$sql = "insert into ".$this->table("books_source")." values(null, '{$book_id}', '{$source_id}', '{$source_url}', 0,'{$time}', '{$time}')";
		return $this->db->query($sql);
	}

	/**
	 * 	获取章节数据
	 *	@param $bid 书籍ID
	 *	@param $sid 源ID
	 *	@param $chapter_name 章节名字
	 */
	public function getBookChapter($bid, $sid, $chapter_name){
		$sql = "select * from ".$this->table("books_chapter").
			" where book_id='{$bid}' and source_id='{$sid}' and chapter_name='{$chapter_name}' order by id desc limit 1";
		return $this->db->get_result($sql);
	}

	public function getBookNewsChapter($bid, $sid, $limit = 1){
		$sql = "select * from ".$this->table("books_chapter").
			" where book_id='{$bid}' and source_id='{$sid}' order by id desc limit 1";
		return $this->db->get_result($sql);
	}

	/**
	 * 添加书籍章节
	 */
	public function addBookChapter($bid, $sid, $source_url, $chapter_name){
		$chapter_info = $this->getBookChapter($bid, $sid, $chapter_name);
		if(!empty($chapter_info)){
			return $chapter_info;
		}

		$chapter_info = $this->getBookNewsChapter($bid, $sid);

		$time = time();
		$sort = 0;

		if(!empty($chapter_info)){
			$sort = $chapter_info[0]['sort'] + 1;
		}

		$ret = $this->db->insertGetId('books_chapter', array(
				'book_id' 		=> $bid,
				'source_id' 	=> $sid,
				'source_url' 	=> $source_url,
				'source_umd5' 	=> md5($source_url),
				'sort' 			=> $sort,
				'chapter_name' 	=> $chapter_name,
				'create_time' 	=> $time,
			));
		return $ret;
	}

	public function addBookPChapter($book_chapter, $book_id, $source_id){
		$list = [];
		$time = time();
		foreach ($book_chapter as $k => $v) {
			$tmp 	= [];
			$tmp['book_id'] 	= $book_id;
			$tmp['source_id'] 	= $source_id;
			$tmp['source_url'] 	= $v['source_url'];
			$tmp['source_umd5'] 	= md5($v['source_url']);
			$tmp['chapter_name'] 	= $v['chapter_name'];
			$tmp['sort'] 			= $k;
			$tmp['create_time'] 	= $time;
			
			$list[] = $tmp;
		}
		$ret = $this->db->insertPGetId('books_chapter', $list);
		return $ret;
	}

	/**
	 * 插入数据信息(第一次添加书籍信息)
	 * @param $book_info 书籍基本信息
	 * @param $book_chapter 书籍章节信息
	 */
	public function addBookInfoAndChapter($book_info, $book_chapter){
		$book_id = $this->addBook($book_info);

		// var_dump($book_info, $book_chapter);
		// exit;
		if($book_id){
			$ret = $this->addBookSource($book_id, $book_info['source_id'], $book_info['source_url']);
			if($ret){
				$chapter_info = $this->getBookNewsChapter($book_id, $book_info['source_id']);
				if(!$chapter_info || empty($chapter_info)) {
					$this->addBookPChapter($book_chapter, $book_id, $book_info['source_id']);
				}
				
				return true;
			}
		}
		return false;
	}

}

?>