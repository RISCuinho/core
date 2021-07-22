#-----------------------------------------------------------------------------
#-- Generic Makefile for building FPGA projects using make
#-- https://github.com/FPGAwars/apio-examples/blob/master/Makefile_example/Makefile
#------------------------------------------------------------------------------
#--         HOW TO USE
#--
#-------- DETECT SHELL OS
ifeq ($(findstring cmd.exe,$(SHELL)),cmd.exe)
   $(info "shell Windows cmd.exe")
   DEVNUL := NUL
   WHICH := where
else
   $(info "shell Bash")
   DEVNUL := /dev/null
   WHICH := which
endif

#-------- TOOLS INSTALLATION
#--
#--  Make sure all the tools are in the PATH
#--
CMDS_EXEC = gtkwave iverilog 
CHECK_RESULT := $(foreach CHECK_CMD,$(CMDS_EXEC),\
        $(if $(shell ${WHICH} $(CHECK_CMD) 2>${DEVNUL} ),\
            $(CHECK_CMD) found,\
         $(error "No $(CHECK_CMD) in PATH")))
$(info ${CHECK_RESULT})

## TODO: SHOW VERSION

#------- CONFIGURATION:
#-- Change the variable NAME with the name of the main file (ej. leds)
#-- Change the variable DEPS with the name of the verilog files that are
#--   needed for building (ej. uart.v timer.v)
#--
#--------- SIMULATION --------------------------------------------------------
#--  For simulating the following tools should be installed:
#--
#--  icarus verilog: http://iverilog.icarus.com/
#--  gtkwave: http://gtkwave.sourceforge.net/
#--
#--  Let's say we have the example.v and example_tb.v files.
#--  The manual process for simulating a testbench is:
#--
#--  Generate an executable file from the testbench:
#--  iverilog example_tb.v example.v -o example_tb.out
#--
#--  Execute it
#--  ./leds_tb.out
#--
#--  Show the results:
#--  gtkwave example_tv.vcd example_tb.gtkw
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
#--- CONFIGURATION:  Set the project name (top level entity without extension)
#--  and the dependencies (verilog files with .v extension)
#--  DEPS can be set blank, if no dependencies
#--  or it should contain the dependencies for the top entity:
#--  Ex. DEPS = uart.v timer.v
#------------------------------------------------------------------------------
NAME = RISCuin
DEPS = RegisterBank.v ProgramMemory.v \
			ProgramCountControlUnit.v \
			DataBusControl.v DataMemory.v \
			InstructionDecoderRV32I.v \
			IntegerBasicALU.v \
			IVerilogInstructionTable.v

TOP_MODULE_NAME = $(NAME)_tb

HDL_VER = 2001

FPGA_RTL_PATH = ./src

FPGA_LIB_PATHS = ./lib/LibFPGA/ $(FPGA_RTL_PATH)
FPGA_LIB_PARAMS=$(foreach d, $(FPGA_LIB_PATHS), -I$d)
FPGA_LIB_GIT_TAG = step-by-step
FPGA_LIB_GIT_BRANCH = main

LIBS = ./lib/LibFPGA/AutoReset.v

QUARTUS_PATH = /mnt/c/altera/13.1_Web\ Edition/quartus/bin/
QUARTUS_EXT = .exe

VPATH = $(foreach d, $(FPGA_LIB_PATHS),:$d)

#------------- Simulation of project 1 ---------
sim: $(NAME).vcd
	mkdir -p ./dumps
	rm -f ./dumps/*
	vvp -lxt2 $(<:.vcd=.out)

gtkwave: $(NAME).vcd  
	@echo $< $(<:.vcd=.gtkw)
	gtkwave $< $(<:.vcd=.gtkw) &

quartus: 
	${QUARTUS_PATH}quartus_map$(QUARTUS_EXT) --read_settings_files=on --write_settings_files=off \
										$(NAME) -c $(NAME)
	${QUARTUS_PATH}quartus_fit$(QUARTUS_EXT) --read_settings_files=off --write_settings_files=off \
										$(NAME) -c $(NAME)
	${QUARTUS_PATH}quartus_asm$(QUARTUS_EXT) --read_settings_files=off --write_settings_files=off \
										$(NAME) -c $(NAME)
	${QUARTUS_PATH}quartus_sta$(QUARTUS_EXT) $(NAME) -c $(NAME)
	${QUARTUS_PATH}quartus_eda$(QUARTUS_EXT) --read_settings_files=off --write_settings_files=off \
										$(NAME) -c $(NAME)

quartus_netlist:
	${QUARTUS_PATH}quartus_npp$(QUARTUS_EXT) --netlist_type=sgate \
										$(NAME) -c $(NAME)


#-- set the dependencies for simulation
$(NAME).vcd: $(NAME).v $(DEPS) $(LIBS) $(NAME)_tb.v



# --- Time report
time: $(NAME).rpt


#--------------------------------
#-- General Compilation rules
#--------------------------------

.SUFFIXES: .v .vcd .rpt

#-- Rule for generating the simulations
.v.vcd:
	iverilog $^ ${FPGA_LIB_PARAMS} -s ${TOP_MODULE_NAME} -g${HDL_VER} -o $(@:.vcd=.out)

#-- Clean the project
clean:
	rm -f *.bak *.bin *.asc *.blif *.out *.vcd dumps/* examples/*~ *.rpt

.PHONY: all clean time

#-----------------------------
# RTL VIEW
#-----------------------------

rtlview: CMDS_EXEC = yosys 
rtlview: CHECK_RESULT := $(foreach CHECK_CMD,$(CMDS_EXEC),\
        $(if $(shell ${WHICH} $(CHECK_CMD) 2>${DEVNUL} ),\
            $(CHECK_CMD) found,\
            $(error "No $(CHECK_CMD) in PATH")))
rtlview: $info ${CHECK_RESULT})
rtlview: YOSYS_SCRIPT += verilog_defaults -add -D__YOSYS__; 
rtlview: YOSYS_SCRIPT += $(foreach d, $(LIBS), read_verilog $d;)
rtlview: YOSYS_SCRIPT += $(foreach d, $(DEPS), read_verilog $(FPGA_RTL_PATH)/$d;)
rtlview: YOSYS_SCRIPT += read_verilog  $(FPGA_RTL_PATH)/$(NAME).v;
rtlview: YOSYS_SCRIPT += read_verilog  $(FPGA_RTL_PATH)/$(NAME)_tb.v;
rtlview: YOSYS_SCRIPT += prep -top $(TOP_MODULE_NAME);
#rtlview: YOSYS_SCRIPT += aigmap;
rtlview: YOSYS_SCRIPT += write_json ${NAME}.json;
rtlview: YOSYS_SCRIPT += show -stretch -prefix $(NAME) -format dot
rtlview:
	yosys -p "$(YOSYS_SCRIPT)" 
	dot -Tpng $(NAME).dot -O
	mv $(NAME).dot*.png docs/images

## export DISPLAY="169.254.194.253:0"


## verilog_defaults -add -D__YOSYS__; read_verilog  ../step-by-step-lib/AutoReset.v;  read_verilog  ../step-by-step-lib/MyPLL.v;  read_verilog  ../step-by-step-lib/LFSR.v;  read_verilog  ../step-by-step-lib/LCDControler.v; read_verilog  ../step-by-step-lib/StepByStep_LCD.v; prep; show -stretch -prefix StepByStep_LCD -format dot  -stretch -width
## verilog_defaults -add -D__YOSYS__; read_verilog ../step-by-step-lib/*.v; read_verilog  StepByStep_LCD.v; prep; show -stretch -prefix StepByStep_LCD -format dot  -stretch -width
