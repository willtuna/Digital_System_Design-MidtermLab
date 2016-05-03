onerror {resume}
quietly virtual function -install /test_BCD/bcd -env /test_BCD/bcd { &{/test_BCD/bcd/out[15], /test_BCD/bcd/out[14], /test_BCD/bcd/out[13], /test_BCD/bcd/out[12] }} K
quietly virtual function -install /test_BCD/bcd -env /test_BCD/bcd { &{/test_BCD/bcd/out[11], /test_BCD/bcd/out[10], /test_BCD/bcd/out[9], /test_BCD/bcd/out[8] }} h
quietly virtual function -install /test_BCD/bcd -env /test_BCD/bcd { &{/test_BCD/bcd/out[7], /test_BCD/bcd/out[6], /test_BCD/bcd/out[5], /test_BCD/bcd/out[4] }} d
quietly virtual function -install /test_BCD/bcd -env /test_BCD/bcd { &{/test_BCD/bcd/out[3], /test_BCD/bcd/out[2], /test_BCD/bcd/out[1], /test_BCD/bcd/out[0] }} one
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /test_BCD/bcd/in
add wave -noupdate -radix unsigned /test_BCD/bcd/K
add wave -noupdate -radix unsigned /test_BCD/bcd/h
add wave -noupdate -radix unsigned /test_BCD/bcd/d
add wave -noupdate -radix unsigned /test_BCD/bcd/one
add wave -noupdate -childformat {{{/test_BCD/bcd/out[15]} -radix decimal} {{/test_BCD/bcd/out[14]} -radix decimal} {{/test_BCD/bcd/out[13]} -radix decimal} {{/test_BCD/bcd/out[12]} -radix decimal}} -expand -subitemconfig {{/test_BCD/bcd/out[15]} {-height 15 -radix decimal} {/test_BCD/bcd/out[14]} {-height 15 -radix decimal} {/test_BCD/bcd/out[13]} {-height 15 -radix decimal} {/test_BCD/bcd/out[12]} {-height 15 -radix decimal}} /test_BCD/bcd/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {71 ns} 0}
quietly wave cursor active 1
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
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ns} {1 us}
