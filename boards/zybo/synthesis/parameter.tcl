#
# Parameter for Sample Project
#
set  project_name        "sample_project"
set  project_directory   runs
set  board_part          [get_board_parts -quiet -latest_file_version "*zybo*"]
set  device_parts        "xc7z010clg400-1"
set  design_pin_xdc_file "../xdc/base.xdc"

set  create_bd_design     "create_bd_design.tcl"
set  
