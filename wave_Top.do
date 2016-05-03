onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Test_Top/in
add wave -noupdate -radix binary /Test_Top/row_sweep
add wave -noupdate -radix binary /Test_Top/Midterm_Top/column_in
add wave -noupdate -radix binary /Test_Top/Midterm_Top/keypad/keypad_sweep/press_pos
add wave -noupdate -radix decimal /Test_Top/Midterm_Top/enc_out
add wave -noupdate /Test_Top/Midterm_Top/pressed
add wave -noupdate -group Top -radix decimal /Test_Top/Midterm_Top/digit1
add wave -noupdate -group Top -radix decimal /Test_Top/Midterm_Top/digit2
add wave -noupdate -group Top -radix decimal /Test_Top/Midterm_Top/digit3
add wave -noupdate -group Top -radix decimal /Test_Top/Midterm_Top/digit4
add wave -noupdate -radix binary /Test_Top/Midterm_Top/seven_out
add wave -noupdate -radix binary /Test_Top/Midterm_Top/seven_select
add wave -noupdate /Test_Top/Midterm_Top/fsm_data/A0
add wave -noupdate /Test_Top/Midterm_Top/fsm_data/A1
add wave -noupdate /Test_Top/Midterm_Top/fsm_data/B0
add wave -noupdate /Test_Top/Midterm_Top/fsm_data/B1
add wave -noupdate /Test_Top/Midterm_Top/fsm_data/OP
add wave -noupdate /Test_Top/Midterm_Top/fsm_data/a0
add wave -noupdate /Test_Top/Midterm_Top/fsm_data/a1
add wave -noupdate /Test_Top/Midterm_Top/fsm_data/b0
add wave -noupdate /Test_Top/Midterm_Top/fsm_data/b1
add wave -noupdate /Test_Top/Midterm_Top/fsm_data/op
add wave -noupdate /Test_Top/Midterm_Top/fsm_data/digit1
add wave -noupdate /Test_Top/Midterm_Top/fsm_data/digit2
add wave -noupdate /Test_Top/Midterm_Top/fsm_data/digit3
add wave -noupdate /Test_Top/Midterm_Top/fsm_data/digit4
add wave -noupdate /Test_Top/Midterm_Top/fsm_data/in
add wave -noupdate /Test_Top/Midterm_Top/fsm_data/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {987771 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 267
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
configure wave -timelineunits ms
update
WaveRestoreZoom {101866602 ns} {110438612 ns}
