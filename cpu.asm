; MIPS Lite

ori $v0, $zero, 38
ori $v1, $zero, 52
add $s0, $v1, $v0
label: sw $v0, 1($s0)
lw $v1, 1($s0)
beq $v0, $v1, label
