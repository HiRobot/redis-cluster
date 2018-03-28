
source ./base.conf

for i in $INSTANCE
do
	$REDIS_CLIENT -p $i shutdown
done
