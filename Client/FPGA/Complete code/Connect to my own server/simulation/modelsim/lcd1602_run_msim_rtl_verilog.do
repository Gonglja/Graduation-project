transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source {C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source/esp8266_encode.v}
vlog -vlog01compat -work work +incdir+C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source {C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source/esp8266_decode.v}
vlog -vlog01compat -work work +incdir+C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source {C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source/clk_set.v}
vlog -vlog01compat -work work +incdir+C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source {C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source/pwm.v}
vlog -vlog01compat -work work +incdir+C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source {C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source/pid_control.v}
vlog -vlog01compat -work work +incdir+C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source {C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source/lcd1602.v}
vlog -vlog01compat -work work +incdir+C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source {C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source/w_dale.v}
vlog -vlog01compat -work work +incdir+C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source {C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source/uart_tx.v}
vlog -vlog01compat -work work +incdir+C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source {C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source/uart_rx.v}
vlog -vlog01compat -work work +incdir+C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source {C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source/top.v}
vlog -vlog01compat -work work +incdir+C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source {C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source/angle_dale.v}
vlog -vlog01compat -work work +incdir+C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source {C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/source/ReceiveMessage_control.v}

vlog -vlog01compat -work work +incdir+C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0 {C:/Users/wslibeia/Desktop/fenglibai(UART)(E)/Code/V1.0/tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run 1 ms
