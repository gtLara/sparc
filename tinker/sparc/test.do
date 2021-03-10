view wave
delete wave *
add wave uut/u_alu/*
add wave uut/u_signex/*
add wave uut/u_alu_mux/*
add wave uut/u_register_file/*
add wave uut/u_instruction_memory/*
add wave uut/u_program_counter/*
add wave uut/u_data_mem/*
add wave uut/u_control/*
add wave uut/u_ps_register/*
add wave uut/u_alu_mux/*
add wave uut/u_pc_mux/*
add wave uut/u_branch_and/*
when {sim:/tb_sparc/uut/u_program_counter/next_instruction_address == "01010"} {
  stop
  echo "Test: OK"
}
run -all
