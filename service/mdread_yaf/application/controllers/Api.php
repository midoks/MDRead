<?php
/**
 *	接口数据
 */

class ApiController extends BaseController{


	public function indexAction(){

		$address = $this->getUrl();

		//AD地址
		$info['ad'] 			= $address.'ad';
		$info['search'] 		= $address.'book/search';//$address.'book/search/w/{/keyword}';
		$info['book_list'] 		= $address.'book/list'; //book_id/{/book_id}/source_id/{/source_id}
		$info['book_content'] 	= $address.'book/content';//chapter_id/{/chapter_id}/source_id/{/source_id}
		$info['book_source'] 	= $address.'book/source';///book_id/{/book_id}
		$info['book_author'] 	= $address.'book/authorlist';//book_author/{/book_author}/book_id/{/book_id}

		$info['recommend'] 		= $address.'book/recommend';
		$info['rand']			= $address.'book/rand';
		$info['list']			= $address.'book/bang_list';


		$info['vaildata'] 	= [
			'search'	=> '修',
			'book_list'	=> [
				'book_id' 	=> '1',
				'source_id' => '1',
			],
			'book_content' => [
				'chapter_id' => '1',
				'source_id'  => '1',
			],
		];

		// $rsa = new rsaModel();
		// $key = $rsa->getPublicKey();
		// $info['public_key'] = $key;

		return $this->retJson($info);
	}

}
?>
