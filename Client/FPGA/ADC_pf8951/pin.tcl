
#------------------GLOBAL--------------------#
set_location_assignment PIN_E15 -to clk
set_location_assignment PIN_R9 -to ren

#rst_n
set_location_assignment PIN_M16 -to rst_n

#i2c
set_location_assignment PIN_D5 -to scl
set_location_assignment PIN_C2 -to sda


#dpy
set_location_assignment PIN_B11 -to en
set_location_assignment PIN_A12 -to dig_sel[2]
set_location_assignment PIN_B10 -to dig_sel[1]
set_location_assignment PIN_A10 -to dig_sel[0]
set_location_assignment PIN_K5  -to dig_num[7]
set_location_assignment PIN_D14 -to dig_num[6]
set_location_assignment PIN_J1 -to dig_num[5]
set_location_assignment PIN_K1 -to dig_num[4]
set_location_assignment PIN_N2 -to dig_num[3]
set_location_assignment PIN_L3 -to dig_num[2]
set_location_assignment PIN_L1 -to dig_num[1]
set_location_assignment PIN_L2 -to dig_num[0]

