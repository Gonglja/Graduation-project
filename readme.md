基于FPGA的机房环境采集监控系统设计

## 实现功能

### 客户端

#### Fpga

1. 模拟各传感器的时序（单总线协议(DHT11)、IIC协议（pcf8591）），读出温度、湿度、烟雾等等。

2. 编写UART协议实现对esp8266的收发。

#### Esp8266

使用乐鑫Nonos-SDK

1. esp8266的联网
2. MQTT协议的编写
3. 消息的订阅及收发
4. UART串口的通信

#### Web

使用python作为开发的语言

1. MQTT协议的客户端
2. 网页端折线图的绘制
3. 线程间消息的传递

##### Android

  使用已有的[IoT MQTT Panel](http://www.snrelectronicsblog.com/iot/iot-mqtt-panel-user-guide/)作为MQTT协议的客户端

### 服务端

1. 创建服务器  使用开源物联网MQTT消息服务器emq作为通信的服务端
2. 开放端口

| 端口号 | 说明                     |
| ------ | ------------------------ |
| 1883   | MQTT 协议端口            |
| 8883   | MQTT/SSL 端口            |
| 8083   | MQTT/WebSocket 端口      |
| 8080   | HTTP API 端口            |
| 18083  | Dashboard 管理控制台端口 |

