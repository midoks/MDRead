<?php
//第一次,亲密接触


class IndexController extends BaseController{

	public function indexAction(){
		return $this->retJson(array(
			'ret_code' 	=> -1,
			'ret_msg'	=> 'hi life',
		));
	}
}
?>
