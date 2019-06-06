transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Gonglja/Desktop/Connect\ to\ my\ own\ server/source {C:/Users/Gonglja/Desktop/Connect to my own server/source/ad.v}
vlog -vlog01compat -work work +incdir+C:/Users/Gonglja/Desktop/Connect\ to\ my\ own\ server/source {C:/Users/Gonglja/Desktop/Connect to my own server/source/dvf.v}
vlog -vlog01compat -work work +incdir+C:/Users/Gonglja/Desktop/Connect\ to\ my\ own\ server/source {C:/Users/Gonglja/Desktop/Connect to my own server/source/dht11.v}
vlog -vlog01compat -work work +incdir+C:/Users/Gonglja/Desktop/Connect\ to\ my\ own\ server/source {C:/Users/Gonglja/Desktop/Connect to my own server/source/esp8266_encode.v}
vlog -vlog01compat -work work +incdir+C:/Users/Gonglja/Desktop/Connect\ to\ my\ own\ server/source {C:/Users/Gonglja/Desktop/Connect to my own server/source/esp8266_decode.v}
vlog -vlog01compat -work work +incdir+C:/Users/Gonglja/Desktop/Connect\ to\ my\ own\ server/source {C:/Users/Gonglja/Desktop/Connect to my own server/source/clk_set.v}
vlog -vlog01compat -work work +incdir+C:/Users/Gonglja/Desktop/Connect\ to\ my\ own\ server/source {C:/Users/Gonglja/Desktop/Connect to my own server/source/lcd1602.v}
vlog -vlog01compat -work work +incdir+C:/Users/Gonglja/Desktop/Connect\ to\ my\ own\ server/source {C:/Users/Gonglja/Desktop/Connect to my own server/source/uart_tx.v}
vlog -vlog01compat -work work +incdir+C:/Users/Gonglja/Desktop/Connect\ to\ my\ own\ server/source {C:/Users/Gonglja/Desktop/Connect to my own server/source/uart_rx.v}
vlog -vlog01compat -work work +incdir+C:/Users/Gonglja/Desktop/Connect\ to\ my\ own\ server/source {C:/Users/Gonglja/Desktop/Connect to my own server/source/top.v}
vlog -vlog01compat -work work +incdir+C:/Users/Gonglja/Desktop/Connect\ to\ my\ own\ server/source {C:/Users/Gonglja/Desktop/Connect to my own server/source/ReceiveMessage_control.v}

vlog -vlog01compat -work work +incdir+C:/Users/Gonglja/Desktop/Connect\ to\ my\ own\ server/source {C:/Users/Gonglja/Desktop/Connect to my own server/source/tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run 100 us
