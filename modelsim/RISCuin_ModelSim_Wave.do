onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /RISCuin_tb/cpu/clk
add wave -noupdate /RISCuin_tb/cpu/rd_sel
add wave -noupdate /RISCuin_tb/cpu/rs1_sel
add wave -noupdate /RISCuin_tb/cpu/rs2_sel
add wave -noupdate /RISCuin_tb/cpu/rd_data_sel
add wave -noupdate /RISCuin_tb/cpu/rs1_data
add wave -noupdate /RISCuin_tb/cpu/rs2_data
add wave -noupdate /RISCuin_tb/cpu/imm
add wave -noupdate /RISCuin_tb/cpu/data_m_ctl/local_data_out
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
