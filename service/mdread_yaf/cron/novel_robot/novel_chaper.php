<?php
function openUrl( $url , $option = '' ){
	//��ʼ������
	$go = curl_init();
	//����URL��ַ
	curl_setopt($go , CURLOPT_URL , $url);
	curl_setopt($go , CURLOPT_HEADER , 0);
	//�����Ƿ������ת
	curl_setopt($go , CURLOPT_FOLLOWLOCATION , 1);
	//������ת�Ĵ���
	curl_setopt($go , CURLOPT_MAXREDIRS , 30);
	curl_setopt($go , CURLOPT_USERAGENT , $_SERVER['HTTP_USER_AGENT']);
	//ͷ�ļ�
	curl_setopt($go , CURLOPT_HEADER , 0 );
	//����������
	curl_setopt($go , CURLOPT_RETURNTRANSFER , 1);
	//Cookie �ļ��Ķ�ȡ
	//curl_setopt($go , CURLOPT_COOKIEJAR , $cookie_file);
	//���еĳ�ʱʱ��
	$data = curl_exec( $go );
	//�����е���Ϣ
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