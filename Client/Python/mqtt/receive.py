#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 19/1/12 15:32
# @Author  : GLJ
# @File    : receive.py
# @Software: PyCharm+python3.7

import paho.mqtt.client as mqtt
import time


HOST = "139.199.95.172"
PORT = 1883

def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))
    client.subscribe("test")


def on_message(client, userdata, msg):
    global return_msg
    return_msg = msg.payload.decode("utf-8")
    print(msg.topic + " " +return_msg)

def client_loop():
    client_id = time.strftime('%Y%m%d%H%M%S', time.localtime(time.time()))
    client = mqtt.Client(client_id)  # ClientId不能重复，所以使用当前时间
    client.username_pw_set("admin_py", "0800")  # 必须设置，否则会返回「Connected with result code 4」
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(HOST, PORT, 60)
    client.loop_forever()


if __name__ == '__main__':
    client_loop()