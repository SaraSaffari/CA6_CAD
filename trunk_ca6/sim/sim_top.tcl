
	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"tb_top"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
#	set run_time			"1 us"
	set run_time			"-all"

#============================ Add verilog files  ===============================
	
	vlog -sv	+acc -incr -source  +define+SIM 	$hdl_path/*.v
	
	vlog 	+acc -incr -source  +define+SIM 	EmulatorModule/SRAM_Emulator.v
	vlog 	+acc -incr -source  +define+SIM 	EmulatorModule/VGA_Emulator.v
	
	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.v
#	onerror {break}

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================
	

	add wave -dec -group 	 	{Parameter}			sim:/$TB/IMAGE_WIDTH
	add wave -dec -group 	 	{Parameter}			sim:/$TB/IMAGE_HEIGHT
	add wave -dec -group 	 	{Parameter}			sim:/$TB/SRAM_INIT_SIZE
	add wave -radix ascii -group {Parameter}		sim:/$TB/INIT_FILE_NAME
	add wave -dec -group 	 	{Parameter}			sim:/$TB/SRAM_INIT_START
	add wave -dec -group 	 	{Parameter}			sim:/$TB/CONVERSION_READ_ADDR_BASE
	add wave -dec -group 	 	{Parameter}			sim:/$TB/CONVERSION_WRITE_ADDR_BASE
	
	add wave -hex -group 	 	{SRAM_Emulator}		sim:/$TB/SRAM_Emulator/*
	add wave -hex -group 	 	{VGA_Emulator}		sim:/$TB/VGA_Emulator/*
	add wave -hex -group 	 	{TB}				sim:/$TB/*
	add wave -hex -group 	 	{top}				sim:/$TB/decompressor_top/*	
	add wave -hex -group 	 	{SRAM_VGA}			sim:/$TB/decompressor_top/sram_vga_controller/*
	add wave -hex -group 	 	{DCT_INVERSE}			sim:/$TB/decompressor_top/dctitop/*
	

	add wave  -group Conversion -group {cntrl}	
	add wave -hex -group 	 	{cntrl}		sim:/$TB/decompressor_top/yuv_to_rgb_conversion/yuv_ctlr/*
	add wave  -group Conversion -group {dp}
	add wave -hex -group 	 	{dp}		sim:/$TB/decompressor_top/yuv_to_rgb_conversion/yuv_dp/*
	add wave -hex -group -r		{all}				sim:/$TB/*
	
	add wave -hex -group 	 	{UPSAMPLE}			sim:/$TB/decompressor_top/upsampling_top/*
	

	
#=========================== Configure wave signals =============================
	
	configure wave -signalnamewidth 2
    

#====================================== run =====================================

	run $run_time 
	