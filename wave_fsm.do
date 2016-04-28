onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /test_fsm/clk
add wave -noupdate -radix decimal /test_fsm/d1
add wave -noupdate -radix decimal /test_fsm/d2
add wave -noupdate -radix decimal /test_fsm/d3
add wave -noupdate -radix decimal /test_fsm/d4
add wave -noupdate -radix binary /test_fsm/in
add wave -noupdate -radix binary /test_fsm/pressed
add wave -noupdate -radix binary /test_fsm/fsm/next_st_in
add wave -noupdate -radix binary /test_fsm/fsm/state
add wave -noupdate /test_fsm/rst
add wave -noupdate /test_fsm/fsm/A0
add wave -noupdate /test_fsm/fsm/A1
add wave -noupdate /test_fsm/fsm/B0
add wave -noupdate /test_fsm/fsm/B1
add wave -noupdate -radix binary /test_fsm/fsm/OP
add wave -noupdate -radix decimal /test_fsm/fsm/answer
add wave -noupdate -radix decimal /test_fsm/fsm/cal/A1
add wave -noupdate /test_fsm/fsm/cal/A0
add wave -noupdate /test_fsm/fsm/cal/B1
add wave -noupdate /test_fsm/fsm/cal/B0
add wave -noupdate /test_fsm/fsm/cal/OP
add wave -noupdate /test_fsm/fsm/cal/rst
add wave -noupdate /test_fsm/fsm/cal/out
add wave -noupdate /test_fsm/fsm/cal/out_temp
add wave -noupdate /test_fsm/fsm/cal/A
add wave -noupdate /test_fsm/fsm/cal/B
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {870 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 200
configure wave -valuecolwidth 118
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
WaveRestoreZoom {0 ns} {6636 ns}
