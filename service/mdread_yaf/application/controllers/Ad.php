<?php

//测试
class AdController extends BaseController{

	public function indexAction(){

		$address = $this->getUrl();
		//AD
		$info['ad'] = [
			'index' => [
				'type' => 'image',//image,video
				'addr' => $address
				],
			'chapter' => [
				'type' => 'image',//image,video
				'addr' => 'addr'
				]
		];
		$info['test'] = 'oh,you known';
		return $this->retJson($info);
	}
}
?>
