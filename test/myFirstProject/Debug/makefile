################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

CG_TOOL_ROOT := C:/ProgramData/App-V/52EB7CA7-C912-4647-896C-AD7297F4555C/A88AFD82-1D4C-4381-87C8-2C47506DA387/Root/ccsv8/tools/compiler/ti-cgt-c6000_8.2.4

GEN_OPTS__FLAG := 
GEN_CMDS__FLAG := 

ORDERED_OBJS += \
"./ISRs.obj" \
"./LCDK_Support_DSP.obj" \
"./StartUp.obj" \
"./main.obj" \
"./vectors.obj" \
"../link6748e.cmd" \
$(GEN_CMDS__FLAG) \
-llibc.a \

-include ../makefile.init

RM := DEL /F
RMDIR := RMDIR /S/Q

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir_vars.mk
-include subdir_rules.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C55_DEPS)),)
-include $(C55_DEPS)
endif
ifneq ($(strip $(C_UPPER_DEPS)),)
-include $(C_UPPER_DEPS)
endif
ifneq ($(strip $(S67_DEPS)),)
-include $(S67_DEPS)
endif
ifneq ($(strip $(S62_DEPS)),)
-include $(S62_DEPS)
endif
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(OPT_DEPS)),)
-include $(OPT_DEPS)
endif
ifneq ($(strip $(C??_DEPS)),)
-include $(C??_DEPS)
endif
ifneq ($(strip $(ASM_UPPER_DEPS)),)
-include $(ASM_UPPER_DEPS)
endif
ifneq ($(strip $(S??_DEPS)),)
-include $(S??_DEPS)
endif
ifneq ($(strip $(C64_DEPS)),)
-include $(C64_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
ifneq ($(strip $(S64_DEPS)),)
-include $(S64_DEPS)
endif
ifneq ($(strip $(INO_DEPS)),)
-include $(INO_DEPS)
endif
ifneq ($(strip $(CLA_DEPS)),)
-include $(CLA_DEPS)
endif
ifneq ($(strip $(S55_DEPS)),)
-include $(S55_DEPS)
endif
ifneq ($(strip $(SV7A_DEPS)),)
-include $(SV7A_DEPS)
endif
ifneq ($(strip $(C62_DEPS)),)
-include $(C62_DEPS)
endif
ifneq ($(strip $(C67_DEPS)),)
-include $(C67_DEPS)
endif
ifneq ($(strip $(PDE_DEPS)),)
-include $(PDE_DEPS)
endif
ifneq ($(strip $(K_DEPS)),)
-include $(K_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(C++_DEPS)),)
-include $(C++_DEPS)
endif
ifneq ($(strip $(C43_DEPS)),)
-include $(C43_DEPS)
endif
ifneq ($(strip $(S43_DEPS)),)
-include $(S43_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
ifneq ($(strip $(SA_DEPS)),)
-include $(SA_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
EXE_OUTPUTS += \
myFirstProject2.out \

EXE_OUTPUTS__QUOTED += \
"myFirstProject2.out" \

BIN_OUTPUTS += \
myFirstProject2.hex \

BIN_OUTPUTS__QUOTED += \
"myFirstProject2.hex" \


# All Target
all: $(OBJS) $(CMD_SRCS) $(GEN_CMDS)
	@$(MAKE) --no-print-directory -Onone "myFirstProject2.out"

# Tool invocations
myFirstProject2.out: $(OBJS) $(CMD_SRCS) $(GEN_CMDS)
	@echo 'Building target: "$@"'
	@echo 'Invoking: C6000 Linker'
	"C:/ProgramData/App-V/52EB7CA7-C912-4647-896C-AD7297F4555C/A88AFD82-1D4C-4381-87C8-2C47506DA387/Root/ccsv8/tools/compiler/ti-cgt-c6000_8.2.4/bin/cl6x" -mv6740 -g --diag_warning=225 --diag_wrap=off --display_error_number -z -m"myFirstProject2.map" -i"C:/ProgramData/App-V/52EB7CA7-C912-4647-896C-AD7297F4555C/A88AFD82-1D4C-4381-87C8-2C47506DA387/Root/ccsv8/tools/compiler/ti-cgt-c6000_8.2.4/lib" -i"C:/ProgramData/App-V/52EB7CA7-C912-4647-896C-AD7297F4555C/A88AFD82-1D4C-4381-87C8-2C47506DA387/Root/ccsv8/tools/compiler/ti-cgt-c6000_8.2.4/include" --reread_libs --diag_wrap=off --display_error_number --warn_sections --xml_link_info="myFirstProject2_linkInfo.xml" --rom_model -o "myFirstProject2.out" $(ORDERED_OBJS)
	@echo 'Finished building target: "$@"'
	@echo ' '

myFirstProject2.hex: $(EXE_OUTPUTS)
	@echo 'Building files: $(strip $(EXE_OUTPUTS__QUOTED))'
	@echo 'Invoking: C6000 Hex Utility'
	"C:/ProgramData/App-V/52EB7CA7-C912-4647-896C-AD7297F4555C/A88AFD82-1D4C-4381-87C8-2C47506DA387/Root/ccsv8/tools/compiler/ti-cgt-c6000_8.2.4/bin/hex6x"  -o "myFirstProject2.hex" $(EXE_OUTPUTS__QUOTED)
	@echo 'Finished building: $(strip $(EXE_OUTPUTS__QUOTED))'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(BIN_OUTPUTS__QUOTED)$(EXE_OUTPUTS__QUOTED)
	-$(RM) "ISRs.obj" "LCDK_Support_DSP.obj" "StartUp.obj" "main.obj" "vectors.obj" 
	-$(RM) "ISRs.d" "LCDK_Support_DSP.d" "StartUp.d" "main.d" 
	-$(RM) "vectors.d" 
	-@echo 'Finished clean'
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets

