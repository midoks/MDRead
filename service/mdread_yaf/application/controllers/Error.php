<?php
//第一次,亲密接触


class ErrorController  extends BaseController{


	public function errorAction($exception) {

        switch ($exception->getCode()) {  
            case YAF_ERR_NOTFOUND_MODULE:  
            case YAF_ERR_NOTFOUND_CONTROLLER:
            case YAF_ERR_NOTFOUND_ACTION:  
            case YAF_ERR_NOTFOUND_VIEW:  
                return $this->retJson(['ret_code'=>-1,'ret_msg'=>'error request !!']);
                break;  
            default :  
                $message = $exception->getMessage();  
                echo 0, ":", $exception->getMessage();  
                break;  
        } 
     } 
}
?>
