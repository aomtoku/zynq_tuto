#
# Create Project
#
set  project_name  "sample_project"
set  project_directory  runs
set  board_part          [get_board_parts -quiet -latest_file_version "*zybo*"]
set  device_parts        "xc7z010clg400-1"
set  design_pin_xdc_file "../xdc/base.xdc"

create_project -force $project_name $project_directory

set_property "board_part" $board_part [current_project]
set_property "default_lib" "xil_defaultlib" [current_project]
set_property "simulator_language" "Mixed" [current_project]
set_property "target_language" "Verilog" [current_project]
#
# Import Constrain files
#
add_files -fileset constrs_1 -norecurse ./${design_pin_xdc_file}
set_property used_in_synthesis true [get_files ./${design_pin_xdc_file}]

#
# IP Catalog Configuration
#
lappend ip_repo_path_list  "../ip_catalog/lib/ADI/axi_i2s_adi_1.0"
lappend ip_repo_path_list  "../ip_catalog/lib/Digilent/axi_dispctrl_1.0"
lappend ip_repo_path_list  "../ip_catalog/lib/Digilent/hdmi_tx_1.0"
puts $ip_repo_path_list
set_property ip_repo_paths $ip_repo_path_list [current_fileset]
update_ip_catalog

#
# Create Block Design (exported by Vivado GUI Project)
#
source "create_bd_design.tcl"
regenerate_bd_layout
save_bd_design
set design_bd_name  [get_bd_designs]
make_wrapper -files [get_files $design_bd_name.bd] -top -import

#
# Create run "synth_1" and set property
#
set synth_1_flow     "Vivado Synthesis 2015"
set synth_1_strategy "Vivado Synthesis Defaults"
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -flow $synth_1_flow -strategy $synth_1_strategy -constrset constrs_1
} else {
    set_property flow     $synth_1_flow     [get_runs synth_1]
    set_property strategy $synth_1_strategy [get_runs synth_1]
}
current_run -synthesis [get_runs synth_1]

#
# Create run "impl_1" and set property
#
set impl_1_flow      "Vivado Implementation 2015"
set impl_1_strategy  "Vivado Implementation Defaults"
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -flow $impl_1_flow -strategy $impl_1_strategy -constrset constrs_1 -parent_run synth_1
} else {
    set_property flow     $impl_1_flow      [get_runs impl_1]
    set_property strategy $impl_1_strategy  [get_runs impl_1]
}
current_run -implementation [get_runs impl_1]


