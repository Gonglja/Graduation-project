# FPGA中与ESP8266的连接细节

## Connect to bigiot

esp8266固件：AT指令固件

### 核心思想

通过使用AT命令来实现数据的上传

### 具体步骤实现

//设置WiFi应用模式为Station
AT+CWMODE=1
//连接到WiFi路由器，请将SSID替换为路由器名称，Password替换为路由器WiFi密码
AT+CWJAP="Power Laboratory 1221","Dldz1221!"

以下每次上电都需要重新执行
//连接贝壳物联服务器
AT+CIPSTART="TCP","www.bigiot.net",8181
//设置为透传模式
AT+CIPMODE=1
//进入透传模式
AT+CIPSEND
//验证web端
{"M":"checkin","ID":"7351","K":"87a5ff0d9"}
以上为初始化代码




//更新数据接口消息
{"M":"update","ID":"7351","V":{"7073":"7073"}}

//从串口助手给web发消息
{"M":"say","ID":"7351","C":"21212121"}

//从串口助手给web发命令
{"M":"say","ID":"U5197","NAME":"wslibeia(web)","C":"wwww","T":"1543582812"}

//从串口助手接收到的web端命令
{"M":"say","ID":"U5197","NAME":"wslibeia(web)","C":"play","T":"1543583007"}



https://blog.csdn.net/richardgann/article/details/78663243

http://tool.oschina.net/encode?type=3

https://www.bigiot.net/help/1.html

## Connect to my own server

esp8266固件：[micropython](http://docs.micropython.org/en/latest/esp8266/quickref.html)

### 核心思想

使用emqq协议，通过发布，订阅完成数据的上传与下载

### 具体步骤实现

FPGA使用串口对esp8266发送类似指令 `p.m(“主题”，“消息”)` 

esp8266 使用micyropython编写emqq协议，及发布和订阅命令。