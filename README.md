# normal-relay

normal-relay是对Databus(https://github.com/linkedin/databus) relay部分的一个简易封装，修改配置文件即可方便的部署relay节点。

# 用法

conf目录下准备relay的配置文件(xxx.properties)，以.json结尾的数据源配置文件都会被扫描配置到relay节点中。

启动：./start_relay.sh xxx 后，会自动加载xxx.properties和所有.json结尾的配置文件。
