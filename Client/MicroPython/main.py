# main.py
from simple import MQTTClient


c = MQTTClient("umqtt_client","139.199.95.172", 1883, "admin_esp", "0800")
c.connect()
def m(t,m):   
    c.publish(t, m)
    print("ok")
    #c.disconnect()

m(t="status",m="connect success!")