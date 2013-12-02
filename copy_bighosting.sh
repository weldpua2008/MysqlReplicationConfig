#!/bin/sh
data=`date "+%Y.%m.%d_%H%M"`
mkdir -p /sql/$data/bigh >/dev/null
echo /sql/$data/bigh


for i in `mysql -uroot -pPASSWORD -h 149.154.67.235 -B -N -e  "SHOW DATABASES"|grep -v mysql|grep -v information_schema`;do 
	echo $i; 
#	mysqldump -uroot -pPASSWORD -h 149.154.67.235 $i > /sql/$data/bigh/$i.sql;  
#	mysqldump -uroot -pPASSWD -h 10.198.101.26  $i > /sql/$data/bigh/$i.sql.10.198.101.26;  
#	mysql -uroot -pPASSWD -h 10.198.101.26 $i < /sql/$data/bigh/$i.sql;
done

#for i in `mysql -uroot -pPASSWORD -h 149.154.67.235 -B -N -e  "SELECT user, host FROM user" mysql|grep -v root|grep -v debian-sys-maint|awk '{print $1"@"$2}'`;do

for i in `mysql -uroot -pPASSWORD -h 149.154.67.235 -B -N -e  "SELECT user, host FROM user" mysql|grep -v root|grep -v debian-sys-maint|awk '{print "\"" $1 "\"@\"" $2 "\""}'`;do

#mysql -uroot -pPASSWORD -h 149.154.67.235 -B -N -e  "SHOW GRANTS FOR $i" |tr -s '\r\n' '\n'|awk '{print $0";"}'
#echo "--------------"
mysql -uroot -pPASSWORD -h 149.154.67.235 -B -N -e  "SHOW GRANTS FOR $i"|tr -s '\r\n' '\n'|awk '{print $0";"}' | mysql  -uroot -pPASSWD -h 10.198.101.26
done

for i in `mysql -uroot -pPASSWORD -h 149.154.67.235 -B -N -e  "SELECT user, host FROM user" mysql|grep -v root|grep -v debian-sys-maint|awk '{print "\"" $1 "\"@\"" $2 "\""}' |grep -v '%'`;do

#echo "--------------"
mysql -uroot -pPASSWORD -h 149.154.67.235 -B -N -e  "SHOW GRANTS FOR $i" |tr -s '\r\n' '\n'|awk '{print $0";"}' | sed 's/localhost/149.154.69.71/g' | mysql  -uroot -pPASSWD -h 10.198.101.26
mysql -uroot -pPASSWORD -h 149.154.67.235 -B -N -e  "SHOW GRANTS FOR $i" |tr -s '\r\n' '\n'|awk '{print $0";"}' | sed 's/localhost/149.154.67.235/g' | mysql  -uroot -pPASSWD -h 10.198.101.26


done



#mysql -uroot -pPASSWORD -h 149.154.67.235 -B -N -e  "SELECT user, host FROM user" mysql|grep -v root|grep -v debian-sys-maint
