# ./bin/redis-trib.rb create --replicas 1 10.135.177.148:7001 10.135.177.148:7002 10.135.177.148:7003 \
# 10.135.177.148:7004 10.135.177.148:7005 10.135.177.148:7006

source ./base.conf

#### get local ip
localip=`ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'`

#### 
for i in $INSTANCE
do
	cluservers="$cluservers $localip:$i"
done


echo "start execute the commands"
echo "-------------------------"
echo "./bin/redis-trib.rb create --replicas 1 $cluservers"
./bin/redis-trib.rb create --replicas 1 $cluservers
