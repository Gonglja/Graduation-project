# main.py
from simple import MQTTClient


c = MQTTClient("umqtt_client","139.199.95.172", 1883, "admin_esp", "0800")
c.connect()
def m(t,h,s):   
    c.publish("T", t)
    c.publish("H", h)
    c.publish("S", s)
    print("ok")
    #c.disconnect()

#m(t="status",m="connect success!")