基于FPGA的机房环境采集监控系统设计

## 实现功能
使用FPGA采集机房的温湿度、烟雾浓度信息，将数据从本地上传到云端服务器，可打开网页实时监控机房信息，也可使手机联网（互联网）打开相应App监控机房信息。当机房环境剧烈变化时，一方面通过蜂鸣器现场报警，另一方面通过手机APP报警，当机房环境平稳后手动使用APP或者是网页将蜂鸣器关闭。

### 客户端

#### Fpga

1. 模拟各传感器的时序（单总线协议(DHT11)、IIC协议（pcf8591）），读出温度、湿度、烟雾等等。

2. 编写UART协议实现对esp8266数据的收发。

#### Esp8266

使用乐鑫[Nonos-SDK](https://github.com/espressif/ESP8266_NONOS_SDK)或[Micropython ](http://docs.micropython.org/en/latest/esp8266/quickref.html)完成

1. esp8266的联网
2. MQTT协议的编写
3. 消息的订阅及收发
4. UART串口的通信


_注：推荐使用Micropython _


#### Web

使用python和html作为开发的语言

1. 网页端折线图的绘制
2. 前后台的交互
3. 多线程的创建及线程间消息的传递

##### Android

  1. 使用已有的[IoT MQTT Panel](http://www.snrelectronicsblog.com/iot/iot-mqtt-panel-user-guide/)
  2. 使用[Linear-mqtt-dashboard](https://github.com/ravendmaster/linear-mqtt-dashboard)

_注：后者可现实实时折线图_

### 服务端 
1. 创建服务器  使用开源物联网MQTT消息服务器emq作为通信的服务端
2. 开放相关端口

| 端口号 | 说明                     |
| ------ | ------------------------ |
| 1883   | MQTT 协议端口            |
| 8883   | MQTT/SSL 端口            |
| 8083   | MQTT/WebSocket 端口      |
| 8080   | HTTP API 端口            |
| 18083  | Dashboard 管理控制台端口 |

3. 访问域名+18083完成对控制台的控制
4. 在客户端连接到服务器
