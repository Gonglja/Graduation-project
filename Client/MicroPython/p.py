from simple import MQTTClient

# Test reception e.g. with:
# mosquitto_sub -t foo_topic
# 
User = "admin_esp"
Pwd  = "0800"

def m(t,m,server="139.199.95.172",port=1883):
    c = MQTTClient("umqtt_client", server, port, User, Pwd)
    c.connect()
    c.publish(t, m)
    c.disconnect()
