# redis-cluster
## 功能描述
   一般配置redis集群和哨兵需要写很多内容基本重复但是端口等存在差异的类似的配置文件，这里使用shell脚本自动生成这些文件。减少人为错误发生，提高部署效率。

## 使用步骤
- 搭建redis环境和ruby环境，[构建过程和基本配置](http://note.youdao.com/noteshare?id=4de0d1564ba9a801019cb0f2c816dda9&sub=5FE411C608914E248DFF87DE32FCA645) 
- 修改base.conf基本配置信息，来自动生成配置文件。名字都是自解释的。
- 进入redis-cluster目录
- 运行./clu-pre.sh用来生成集群配置文件和工作目录。
- 运行./clu-run.sh启动集群。
- 运行./sen-pre.sh用来生成哨兵集群配置文件和工作目录，**注意集群本身具有failover功能**，可以不启动哨兵一样可以做到HA。
