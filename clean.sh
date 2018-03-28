source ./base.conf

for i in $INSTANCE
do
	rm -rf $CLUSTER_HOME/$i/workdir/*
done
