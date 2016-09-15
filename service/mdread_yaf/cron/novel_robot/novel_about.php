<?php
function openUrl( $url , $option = '' ){
	$go = curl_init();
	curl_setopt($go , CURLOPT_URL , $url);
	curl_setopt($go , CURLOPT_HEADER , 0);
	curl_setopt($go , CURLOPT_FOLLOWLOCATION , 1);
	curl_setopt($go , CURLOPT_MAXREDIRS , 30);
	curl_setopt($go , CURLOPT_USERAGENT , $_SERVER['HTTP_USER_AGENT']);
	curl_setopt($go , CURLOPT_HEADER , 0 );
	curl_setopt($go , CURLOPT_RETURNTRANSFER , 1);
	$data = curl_exec( $go );
	curl_close( $go ); 	
	return $data;
}

$catalog_url = "http://www.00ksw.com/html/3/3091/";


$data = openUrl($catalog_url);
//var_dump($data);
preg_match_all( "~<dd><a href=\"(.*)\">(.*)</a></dd>~i", $data , $_content );
var_dump($_content[2]);

?>