onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /TestDisplay/clk
add wave -noupdate -radix binary /TestDisplay/rst
add wave -noupdate -radix binary /TestDisplay/digit1
add wave -noupdate -radix binary /TestDisplay/digit2
add wave -noupdate -radix binary /TestDisplay/digit3
add wave -noupdate -radix binary /TestDisplay/digit4
add wave -noupdate -radix binary /TestDisplay/seven_select
add wave -noupdate -radix binary /TestDisplay/dis/Seven_in
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {44375149 ns} 0} {{Cursor 2} {73306654 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 211
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
WaveRestoreZoom {0 ns} {73306654 ns}
