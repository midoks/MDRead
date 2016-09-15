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

	//https
	curl_setopt($go, CURLOPT_SSL_VERIFYPEER, true);   // 只信任CA颁布的证书  
   // curl_setopt($go, CURLOPT_CAINFO, $cacert); // CA根证书（用来验证的网站证书是否是CA颁布）  
    //curl_setopt($go, CURLOPT_SSL_VERIFYHOST, 2); // 检

	$data = curl_exec( $go );
	curl_close( $go ); 	
	return $data;
}

$novel_name = "小村野地";
$catalog_url = "http://www.baidu.com/s?ie=utf-8&wd=".urlencode($novel_name);


$data = openUrl($catalog_url);
var_dump($data);

//<a target="_blank" href="http://www.baidu.com/link?url=1RDeMduiF9BCm4j6a24t3h8Y9qVtReQUsslZrzAxwWPTvEjo23kBXzoB0jhym26saQ4srDaj-QJ0Cp3gXjND9_" class="c-showurl" style="text-decoration:none;">www.52ranwen.net/book/...&nbsp;</a>

$match = "~cpos=\"title\" href=\"(.*)\" title=\"(.*)\" class=\"result-game-item-title-link\" target=\"_blank\"~i";
preg_match_all( $match, $data , $_content );
var_dump($_content);

?>