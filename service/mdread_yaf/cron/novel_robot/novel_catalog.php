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


$catalog_url = "http://www.00ksw.com/html/3/3091/";




$data = openUrl($catalog_url);

preg_match_all( "~<dd><a href=\"(.*)\">(.*)<\/a><\/dd>~i", $data , $_content );
var_dump($_content);

?>