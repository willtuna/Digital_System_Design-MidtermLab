onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /Test_keypad/clk
add wave -noupdate -radix binary /Test_keypad/keypad/keypad_clk
add wave -noupdate -radix binary /Test_keypad/rst
add wave -noupdate -radix binary /Test_keypad/in
add wave -noupdate -radix binary /Test_keypad/row_select
add wave -noupdate /Test_keypad/keypad/keypad_code
add wave -noupdate -radix unsigned /Test_keypad/enc_out
add wave -noupdate /Test_keypad/pressed
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2198165 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 230
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
WaveRestoreZoom {0 ns} {19950012 ns}
