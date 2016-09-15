<?php 
include('TextSimilarity.class.php');


$obj = new TextSimilarity ('123121231', '你好1212');
echo $obj->run();

?>