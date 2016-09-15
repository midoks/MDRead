#/bin/sh


step=1 #间隔的秒数，不能大于60  
  
for (( i = 0; i < 60; i=(i+step) )); do
    /usr/local/php/bin/php /home/wwwroot/mdread/index.php request_uri="/robot/cronBook"
    sleep $step
done  
  
exit 0  
