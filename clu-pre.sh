source ./base.conf

# work code
mkdir -p $CLUSTER_HOME 

cd $CLUSTER_HOME

#mkdirs
for i in $INSTANCE
do
	echo "mkdir $i"
	mkdir -p $i
	mkdir -p $i/workdir
	#cp $CLUSTER_ROOT/redis.conf $i/redis_$i.conf
done

#replace public config

s1="s:pt_protected-mode:no:g"
s2="s:pt_daemonize:yes:g"

for i in $INSTANCE
do
	#redis instance config.
	s3="s:pt_port:$i:g"
	s4="s:pt_pidfile:$CLUSTER_HOME/$i/workdir/redis_$i.pid:g"
	s5="s:pt_logfile:$CLUSTER_HOME/$i/workdir/redis_$i.log:g"
	s6="s:pt_dir:$CLUSTER_HOME/$i/workdir/:g"

	#cluster config.
	s7="s:pt_nodes-6379.conf:nodes-$i.conf:g"

	sed $s1 $CLUSTER_ROOT/redis.conf |  sed $s2 | sed $s3 | sed $s4 | sed $s5 | sed $s6 | sed $s7 > $CLUSTER_HOME/$i/redis_$i.conf
done


# run the instance
echo ""
echo "#######"
echo "start run redis instances"
pwd
for i in $INSTANCE
do
	$REDIS_SERVER $CLUSTER_HOME/$i/redis_$i.conf
done

