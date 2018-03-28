source ./base.conf

SENTINEL_CONF=$CLUSTER_ROOT/sentinel.conf
CONF_TMP=sen.tmp
TMP_DIR=~/redistmp

#### function declared
function addMasters()
{
	cnt=1
	filepath=$1

	echo "# auto:$filepath"

	for i in $MASTERS	
	do
		server=`echo $i | cut -d':' -f1`
		port=`echo $i | cut -d':' -f2`
		masterName="bigmaster$cnt"

		echo "" >> $filepath 
		echo "### add master $cnt" >> $filepath
		echo "sentinel monitor $masterName $server $port 2" >> $filepath
		echo "sentinel down-after-milliseconds $masterName 60000" >> $filepath
		echo "sentinel failover-timeout $masterName 180000" >> $filepath
		echo "sentinel parallel-syncs $masterName 1" >> $filepath
		echo "" >> $filepath

		let cnt=$cnt+1
	done
	
}


###### clean the old config #########
mkdir -p $TMP_DIR

awk '{ if( $1 ~/^#/ ) print $0; else print "#",$0 }' $SENTINEL_CONF > $TMP_DIR/$CONF_TMP

###### generate public logs  ##########
for i in $SENTINELS
do
	mkdir -p $SENTINEL_HOME/$i/workdir

	SEN_CONF=$SENTINEL_HOME/$i/sentinel_$i.conf
	> $SEN_CONF

	cp -rf $TMP_DIR/$CONF_TMP $SEN_CONF

	echo " " >>  $SEN_CONF
	echo "####>>> config my sentinel <<<< ####" >>  $SEN_CONF
	echo "port $i" >>  $SEN_CONF
	echo "protected-mode no" >> $SEN_CONF
	echo "daemonize yes" >> $SEN_CONF
	echo "dir $SENTINEL_HOME/$i/workdir" >> $SEN_CONF
	echo "logfile $SENTINEL_HOME/$i/workdir/sentinel_$i.log" >> $SEN_CONF
	echo "" >> $SEN_CONF

	addMasters $SEN_CONF
done
