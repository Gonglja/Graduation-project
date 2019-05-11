import network
SSID = ['Power Laboratory 1221','PandoraBox_010203','Gonglja']
PASSWORD = ['Dldz1221!','1552375337a','12345678..']
def do_connect(i):
    import network
    sta_if = network.WLAN(network.STA_IF)
    if not sta_if.isconnected():
        print('connecting to network...')
        sta_if.active(True)
        #sta_if.connect('<essid>', '<password>')
        #for i in range(2):
        sta_if.connect(SSID[i], PASSWORD[i])
        while not sta_if.isconnected():
            pass
    print('network config:', sta_if.ifconfig())

#for i in range(0,3):	
do_connect(1)
    	
