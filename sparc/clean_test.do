view wave
delete wave *
add wave uut/u_alu/*
add wave uut/u_register_file/mem
add wave uut/u_instruction_memory/instruction
add wave uut/u_program_counter/*
add wave uut/u_control/*
add wave uut/u_branch_and/*
delete wave /tb_sparc/uut/u_alu/zero
property wave -radix unsigned /tb_sparc/uut/u_program_counter/*
property wave -radix hex /tb_sparc/uut/u_register_file/*
when {sim:/tb_sparc/uut/u_program_counter/next_instruction_address == "01010"} {
  stop
  echo "Programa chegou ao fim"
}
run -all
