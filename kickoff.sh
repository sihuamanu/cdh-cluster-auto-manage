#!/bin/bash
option=$1
py=cloudera.py
mgmtpy=clouderamgmt.py
hn=ip-172-31-2-173.cn-north-1.compute.internal
path=/cloudera/cluster_auto_manage


echo "$option Cloudera"
echo "----------------"

if [ $option = "start" ]; then
	ssh $hn "$path/cloudera-scm-server-start.sh" 
	echo "cloudera-scm-server starting..."
	sleep 50
	echo "cloudera-scm-server started"
	ssh $hn "$path/cloudera-scm-agent-start.sh; $path/ntpsync.sh"
	python $option$py
	python $option$mgmtpy	
elif [ $option = "stop" ]; then
	python $option$py
	python $option$mgmtpy
	ssh $hn "$path/cloudera-scm-agent-stop.sh; $path/cloudera-scm-server-stop.sh"
elif [ $option = "restart" ]; then
	ssh $hn "$path/cloudera-scm-server-restart.sh"
	echo "cloudera-scm-server restarting..."
	sleep 50
	echo "cloudera-scm-server restarted"
	ssh $hn "$path/cloudera-scm-agent-restart.sh; $path/ntpsync.sh"	
	python $option$py
	python $option$mgmtpy
fi
