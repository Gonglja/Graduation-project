# main.py
from simple import MQTTClient
import utime
from machine import Timer

tim = Timer(-1)
led = machine.PWM(machine.Pin(2), freq=1000)
c = MQTTClient("umqtt_client","xxx.xxx.xxx.xxx", 1883, "admin_esp", "0800")
c.connect()


def sub_cb(topic, msg):
    print(topic, msg)  
    if topic==b'K':
        if msg==b'1':
            led.duty(0) #因为实际IO为0ff时灯是亮的
        if msg==b'0':
            led.duty(1023)
    
def sub():
    c.set_callback(sub_cb)
    c.check_msg()

flag = 1
def m(t,h,s): 
    global flag  
    if(flag):
        c.subscribe(b"K")	 #订阅湿度主题 
        flag = 0

    c.publish("T", t)
    c.publish("H", h)
    c.publish("S", s)
    if(int(s)>20):
        print("b'K' b'1'")
        c.publish("K", "1")
    print("ok")
   
    #c.disconnect()
#if __name__ == "__main__":
    
tim.init(period=500, mode=Timer.PERIODIC, callback= lambda t:sub())

