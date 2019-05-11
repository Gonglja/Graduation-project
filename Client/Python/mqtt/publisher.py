import paho.mqtt.publish as publish
import time

HOST = "139.199.95.172"
PORT = 1883


def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))
    client.subscribe("test")



def on_message(client, userdata, msg):
    print(msg.topic + " " + msg.payload.decode("utf-8"))


if __name__ == '__main__':
    client_id = time.strftime('%Y%m%d%H%M%S', time.localtime(time.time()))
    publish.single("test", "Python客户端-服务器-手机", qos=1, hostname=HOST, port=PORT, client_id=client_id,
                 auth={'username': "admin_py", 'password': "0800"})

