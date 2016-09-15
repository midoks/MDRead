<?php

set_error_handler('catchErr');
set_exception_handler('catchErr');

function catchErr(){
    $list = func_get_args();
    array_pop($list);
    var_dump($list);
}

//ini_set ('memory_limit', '1024M');
define("APP_PATH", str_replace('\\', '/', dirname(__FILE__)).'/' );
$app  = new Yaf_Application(APP_PATH."conf/application.ini");

Yaf_loader::import("plugins/common.php");
Yaf_loader::import("orm/mySqlDb.class.php");
Yaf_loader::import("service/mongoSvc.class.php");

if (php_sapi_name() == 'cli'){

	//exp: cmd --- php index.php request_uri="/robot/"

	$app->getDispatcher()->throwException(true);  
	$app->getDispatcher()->catchException(true);

	Yaf_Dispatcher::getInstance()->disableView();
	$app->getDispatcher()->dispatch(new Yaf_Request_Simple());
	$app->bootstrap();

} else {
	$app->getDispatcher()->throwException(true);
	$app->getDispatcher()->catchException(true);
	$app->bootstrap() //可选的调用
		->run();
}
?>
