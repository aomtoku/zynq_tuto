set app_name            fsbl
set app_type            {Zynq FSBL}
set hw_name             hw_platform_0
set bsp_name            afsbl_bsp
set hwspec_file         system_wrapper.hdf
set proc_name           ps7_cortexa9_0
set project_directory   runs
set workspace           [file join $project_directory "sample_project.sdk"]

sdk set_workspace $workspace
sdk create_hw_project -name $hw_name -hwspec [file join $workspace $hwspec_file]
sdk create_app_project -name $app_name -hwproject $hw_name -proc $proc_name -os standalone -lang C -app $app_type -bsp $bsp_name 

sdk build_project -type bsp -name $bsp_name
sdk build_project -type app -name $app_name

exit
