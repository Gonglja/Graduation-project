import time
from simple import MQTTClient
import machine	

User = "admin_esp"
Pwd  = "0800"
flag_mqttconnctl = 1
led = machine.PWM(machine.Pin(2), freq=1000)
# 从订阅接收的消息将传递到此回调
def sub_cb(topic, msg):
    print(topic, msg)
    global flag_mqttconnctl
    
    if topic==b'L':
        if msg==b'ledon':
            led.duty(0) #因为实际IO为0ff时灯是亮的
        if msg==b'ledoff':
            led.duty(1023)
    if topic==b'MC':
        if msg==b'mqttconnopen':
	   flag_mqttconnctl = 1
        if msg==b'mqttconnclose':
	   flag_mqttconnctl = 0
def mqttconnect(server="localhost",port=1883):
    c = MQTTClient("umqtt_client", server,port,User,Pwd)
    c.set_callback(sub_cb)
    c.connect()
    c.subscribe(b"L") #订阅led控制主题
    c.subscribe(b"T")	 #订阅温度主题
    c.subscribe(b"H")	 #订阅湿度主题
    c.subscribe(b"MC")	 #
    
    while flag_mqttconnctl:
        if True:
            # Blocking wait for message
            c.check_msg()
        else:
            # Non-blocking wait for message
            c.check_msg()
            # Then need to sleep to avoid 100% CPU usage (in a real
            # app other useful actions would be performed instead)
            time.sleep(1)

    c.disconnect()

#if __name__ == "__main__":
#    mqttconnect("139.199.95.172")
