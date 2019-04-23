set hdlin_warn_on_mismatch_message "FMR_ELAB-146 FMR_ELAB-149 FMR_VHDL-1002"
read_vhdl -container r -libname WORK -2008 { src/apb_uart.vhd src/slib_clock_div.vhd src/slib_counter.vhd src/slib_edge_detect.vhd src/slib_fifo.vhd src/slib_input_filter.vhd src/slib_input_sync.vhd src/slib_mv_filter.vhd src/uart_baudgen.vhd src/uart_interrupt.vhd src/uart_receiver.vhd src/uart_transmitter.vhd }
set_top r:/WORK/apb_uart
read_sverilog -container i -libname WORK -12 { src/apb_uart.sv src/slib_clock_div.sv src/slib_counter.sv src/slib_edge_detect.sv src/slib_fifo.sv src/slib_input_filter.sv src/slib_input_sync.sv src/slib_mv_filter.sv src/uart_baudgen.sv src/uart_interrupt.sv src/uart_receiver.sv src/uart_transmitter.sv }
set_top i:/WORK/apb_uart
match 
verify
report_hdlin_mismatches
analyze_points -all
quit
