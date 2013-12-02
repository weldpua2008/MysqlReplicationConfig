#!/bin/sh
#rm -rf /sql
mkdir /sql
data=`date "+%Y.%m.%d_%H%M"`
mkdir /sql/$data/
echo /sql/$data/

rm /var/log/mysql/mysql-bin.*
/etc/init.d/mysql restart
 echo >/var/log/daemon.log


#echo "\n"
echo "stop slave;"| mysql -uroot -pPASSWD -h 10.198.101.26
#echo "stop slave;"| mysql -uroot -pPASSWD -h 10.215.70.179
echo "reset slave;"| mysql -uroot -pPASSWD -h 10.198.101.26
#echo "reset slave;"| mysql -uroot -pPASSWD -h 10.215.70.179

echo "FLUSH TABLES WITH READ LOCK;"| mysql -uroot -pPASSWD -h 10.215.70.179


##echo "MASTER on 10.215.70.179"
#echo "----------"
#echo "show master status\G;"| mysql -uroot -pPASSWD -h 10.215.70.179

F=`echo 'show master status\G;'| mysql -uroot -pPASSWD -h 10.215.70.179|grep File`
P=`echo 'show master status\G;'| mysql -uroot -pPASSWD -h 10.215.70.179|grep Position`
f=`echo $F|awk '{print$2}'`
p=`echo $P|awk '{print$2}'`


#for i in `cat /tables.txt`;do 
#	echo $i; 
#	mysqldump -uroot -pPASSWD -h 10.215.70.179 $i > /sql/$data/$i.sql;  
#	mysqldump -uroot -pPASSWD -h 10.198.101.26  $i > /sql/$data/$i.sql.10.198.101.26;  
#	mysql -uroot -pPASSWD -h 10.198.101.26 $i < /sql/$data/$i.sql; 
#done

mysqldump -uroot -pPASSWD -h 10.215.70.179 --all-database > /sql/$data/mysqldump.sql.10.215.70.179
echo "UNLOCK TABLES;"| mysql -uroot -pPASSWD -h 10.215.70.179

mysqldump -uroot -pPASSWD -h 10.198.101.26 --all-database > /sql/$data/mysqldump.sql.10.198.101.26

mysql -uroot -pPASSWD -h 10.198.101.26 < /sql/$data/mysqldump.sql.10.215.70.179

echo "CHANGE MASTER TO MASTER_HOST = \"10.215.70.179\", MASTER_USER = \"replicationuser\", MASTER_PASSWORD = \"4SJSfA8H2HXZQ2jL\", MASTER_LOG_FILE = \"$f\", MASTER_LOG_POS = $p;"| mysql -uroot -pPASSWD -h 10.198.101.26
echo "start slave;"| mysql -uroot -pPASSWD -h 10.198.101.26

#echo "SLAVE on 10.198.101.26"
#echo "show slave status\G;"| mysql -uroot -pPASSWD -h 10.198.101.26

#sleep 3;

F=`echo 'show master status\G;'| mysql -uroot -pPASSWD -h 10.198.101.26|grep File`
P=`echo 'show master status\G;'| mysql -uroot -pPASSWD -h 10.198.101.26|grep Position`
f=`echo $F|awk '{print$2}'`
p=`echo $P|awk '{print$2}'`
#echo "CHANGE MASTER TO MASTER_HOST = \"178.165.24.231\", MASTER_USER = \"replicationuser\", MASTER_PASSWORD = \"4SJSfA8H2HXZQ2jL\", MASTER_LOG_FILE = \"$f\", MASTER_LOG_POS = $p;"| mysql -uroot -pPASSWD -h 10.215.70.179

#echo "SLAVE on 10.215.70.179"
#echo 'show master status\G;'| mysql -uroot -pPASSWD -h 10.215.70.179
#echo "start slave;"| mysql -uroot -pPASSWD -h 10.215.70.179



