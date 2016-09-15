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

$novel_name = "小村野地";
$catalog_url = "http://so.biquge.la/cse/search?q=".urlencode($novel_name)."&click=1&s=7138806708853866527&nsid=";


$data = openUrl($catalog_url);
//var_dump($data);

$match = "~cpos=\"title\" href=\"(.*)\" title=\"(.*)\" class=\"result-game-item-title-link\" target=\"_blank\"~i";
preg_match_all( $match, $data , $_content );
var_dump($_content);

?>