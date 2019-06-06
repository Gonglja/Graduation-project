#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 19/1/18 14:48
# @Author  : GLJ
# @File    : main.py
# @Software: VSC+python3.7

# encoding:utf-8
# !/usr/bin/env python
import psutil
import time

from threading import Lock
from threading import Thread

from flask import Flask, render_template
from flask_socketio import SocketIO

import paho.mqtt.client as mqtt
import paho.mqtt.publish as publish


HOST = "139.199.95.172"
PORT = 1883

#全局变量
Temp = 0
Hum  = 0
Sm   = 0


async_mode = None
app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app, async_mode=async_mode)
thread = None
thread_lock = Lock()


def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))
    client.subscribe("T") #订阅主题  T温度 H湿度 S烟雾浓度
    client.subscribe("H")
    client.subscribe("S")

def on_message(client, userdata, msg):
    #global return_msg
    global Temp
    global Hum
    global Sm
    rec_msg = msg.payload.decode("utf-8")
    if(msg.topic == "T"):
            Temp = rec_msg
    elif (msg.topic == "H"):
            Hum = rec_msg
    elif (msg.topic == "S"):
            Sm = rec_msg
    print(msg.topic + " " +rec_msg)

def client_loop():
    client_id = time.strftime('%Y%m%d%H%M%S', time.localtime(time.time()))
    client = mqtt.Client(client_id)  # ClientId不能重复，所以使用当前时间
    client.username_pw_set("admin_py", "0800")  # 必须设置，否则会返回「Connected with result code 4」
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(HOST, PORT, 60)
    client.loop_forever()


# 后台线程 产生数据，即刻推送至前端
def background_thread():
    count = 0
    while True:
        socketio.sleep(5)
        count += 1
        t = time.strftime('%M:%S', time.localtime())
        # 获取系统时间（只取分:秒）
        # 推送温湿度消息 data 0:时间 1:温度  2:湿度   
        socketio.emit('server_response',{'data': [t, Temp, Hum, Sm], 'count': count},namespace='/Monitor')
        # 注意：这里不需要客户端连接的上下文，默认 broadcast = True


@app.route('/')
def index():
    return render_template('index.html', async_mode=socketio.async_mode)


@socketio.on('connect', namespace='/Monitor')
def test_connect():
    global thread
    with thread_lock:
        if thread is None:
            thread = socketio.start_background_task(target=background_thread)

@socketio.on('button', namespace='/Control')
def handle_my_custom_namespace_event(json):
      print('K ' + str(json))
      client_id = time.strftime('%Y%m%d%H%M%S', time.localtime(time.time()))
      publish.single("K", str(json), qos=0, hostname=HOST, port=PORT, client_id=client_id,auth={'username': "admin_py", 'password': "0800"})

def thread1():
    socketio.run(app, host='0.0.0.0', port=32, debug=False)

def thread2():
    client_loop()

if __name__ == '__main__':
    # 创建线程01，不指定参数
    thread_01 = Thread(target=thread1)
    # 启动线程01
    thread_01.start()

    # 创建线程02，不指定参数
    thread_02 = Thread(target=thread2)
    # 启动线程02
    thread_02.start()

