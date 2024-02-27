sll  $zero,$zero,0
goto:
multu $s2,$s1
divu  $s2,$s1
sll  $s1,$s3,2
srl  $s1,$s3,2
andi $s0,$s1,2
addi $s0,$s1,2
xori $s0,$s1,2
bne  $s1,$s4,goto
j goto
