onerror {resume}

vsim -gui work.RISCuin_tb -t 10ps -hazards -Lf ../FPGA-MyLIB

add wave -position insertpoint  sim:/RISCuin_tb/cpu/clk \
 sim:/RISCuin_tb/cpu/rd_sel \
 sim:/RISCuin_tb/cpu/rs1_sel \
 sim:/RISCuin_tb/cpu/rs2_sel  \
 sim:/RISCuin_tb/cpu/rd_data_sel \
 sim:/RISCuin_tb/cpu/rs1_data \
 sim:/RISCuin_tb/cpu/rs2_data \
 sim:/RISCuin_tb/cpu/imm \
 sim:/RISCuin_tb/cpu/data_m_ctl/local_data_out\
 sim:/RISCuin_tb/cpu/ib_id/full_op_code

add watch sim:/RISCuin_tb/cpu/rb/memory -noglob -x 0.0 -y 13.0 -radix hexadecimal -radixenum default
add watch sim:/RISCuin_tb/cpu/data_m_ctl/memory -noglob -x 249.0 -y 0.0 -radix hexadecimal -radixenum default
add watch sim:/RISCuin_tb/cpu/data_m_ctl/dbc_register -noglob -x 66.0 -y -71.0 -radix hexadecimal -radixenum default

quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /RISCuin_tb/cpu/clk
add wave -noupdate -radix hexadecimal /RISCuin_tb/cpu/rd_sel
add wave -noupdate -radix hexadecimal /RISCuin_tb/cpu/rs1_sel
add wave -noupdate -radix hexadecimal /RISCuin_tb/cpu/rs2_sel
add wave -noupdate -radix hexadecimal /RISCuin_tb/cpu/rd_data_sel
add wave -noupdate -radix hexadecimal /RISCuin_tb/cpu/rs1_data
add wave -noupdate -radix hexadecimal /RISCuin_tb/cpu/rs2_data
add wave -noupdate -radix hexadecimal /RISCuin_tb/cpu/imm
add wave -noupdate -radix hexadecimal /RISCuin_tb/cpu/data_m_ctl/local_data_out
add wave -noupdate -radix hexadecimal /RISCuin_tb/cpu/ib_id/full_op_code
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {7150 ps} {10150 ps}

run -all

