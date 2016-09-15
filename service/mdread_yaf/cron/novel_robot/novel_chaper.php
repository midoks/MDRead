<?php
function openUrl( $url , $option = '' ){
	//初始化连接
	$go = curl_init();
	//设置URL地址
	curl_setopt($go , CURLOPT_URL , $url);
	curl_setopt($go , CURLOPT_HEADER , 0);
	//设置是否可以跳转
	curl_setopt($go , CURLOPT_FOLLOWLOCATION , 1);
	//设置跳转的次数
	curl_setopt($go , CURLOPT_MAXREDIRS , 30);
	curl_setopt($go , CURLOPT_USERAGENT , $_SERVER['HTTP_USER_AGENT']);
	//头文件
	curl_setopt($go , CURLOPT_HEADER , 0 );
	//返回数据流
	curl_setopt($go , CURLOPT_RETURNTRANSFER , 1);
	//Cookie 文件的读取
	//curl_setopt($go , CURLOPT_COOKIEJAR , $cookie_file);
	//运行的超时时间
	$data = curl_exec( $go );
	//传输中的信息
	//$ConnectInfo = curl_getinfo( $go );
	curl_close( $go );
	//$data = GUNzip( $data );	   	
	return $data;
}


// $catalog_url = "http://www.00ksw.com/html/3/3091/1332997.html";
// $data = openUrl($catalog_url);
// preg_match_all( "~<div id=\"content\">(.*)</div>~i", $data , $_content );
// echo($_content[1][0]);

$catalog_url = "http://www.biquge.la/book/12166/5124436.html";
$data = openUrl($catalog_url);
preg_match_all( "~readx\\(\\)\\;</script>(.*)</div>\\s*<script>read3~is", $data , $_content);
echo($_content[1][0]);

//echo json_encode(array("~readx\(\)\;</script>(.*)</div>\s*<script>read3\(\)\;</script~is"));

?>