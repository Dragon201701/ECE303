################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Each subdirectory must supply rules for building sources it contributes
%.obj: ../%.c $(GEN_OPTS) | $(GEN_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C6000 Compiler'
	"C:/ProgramData/App-V/52EB7CA7-C912-4647-896C-AD7297F4555C/A88AFD82-1D4C-4381-87C8-2C47506DA387/Root/ccsv8/tools/compiler/ti-cgt-c6000_8.2.4/bin/cl6x" -mv6740 --include_path="I:/ECE 303/WEEK 3/HW03.6" --include_path="C:/ProgramData/App-V/52EB7CA7-C912-4647-896C-AD7297F4555C/A88AFD82-1D4C-4381-87C8-2C47506DA387/Root/ccsv8/tools/compiler/ti-cgt-c6000_8.2.4/include" -g --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

%.obj: ../%.asm $(GEN_OPTS) | $(GEN_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C6000 Compiler'
	"C:/ProgramData/App-V/52EB7CA7-C912-4647-896C-AD7297F4555C/A88AFD82-1D4C-4381-87C8-2C47506DA387/Root/ccsv8/tools/compiler/ti-cgt-c6000_8.2.4/bin/cl6x" -mv6740 --include_path="I:/ECE 303/WEEK 3/HW03.6" --include_path="C:/ProgramData/App-V/52EB7CA7-C912-4647-896C-AD7297F4555C/A88AFD82-1D4C-4381-87C8-2C47506DA387/Root/ccsv8/tools/compiler/ti-cgt-c6000_8.2.4/include" -g --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '


