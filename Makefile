# FPGA variables
#PROJECT = fpga/encoder_pwm
#SOURCES= src/counter.v
#ICEBREAKER_DEVICE = up5k
#ICEBREAKER_PIN_DEF = fpga/icebreaker.pcf
#ICEBREAKER_PACKAGE = sg48
#SEED = 1

# COCOTB variables
export COCOTB_REDUCED_LOG_FMT=1
export PYTHONPATH := test:$(PYTHONPATH)
export LIBPYTHON_LOC=$(shell cocotb-config --libpython)


# if you run rules with NOASSERT=1 it will set PYTHONOPTIMIZE, which turns off assertions in the tests
test_traffic_lights:
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -o sim_build/sim.vvp -s traffic_lights -s dump -g2012 src/traffic_lights.v test/dump_traffic_lights.v src/ src/datapath.v src/control_unit.v src/counter.v src/glue_logic.v
	PYTHONOPTIMIZE=${NOASSERT} MODULE=test.test_traffic_lights vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp
	! grep failure results.xml

test_counter:
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -o sim_build/sim.vvp -s counter -s dump -g2012 src/counter.v test/dump_counter.v
	PYTHONOPTIMIZE=${NOASSERT} MODULE=test.test_counter vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp
	! grep failure results.xml

test_control_unit:
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -o sim_build/sim.vvp -s control_unit -s dump -g2012 src/control_unit.v test/dump_control_unit.v
	PYTHONOPTIMIZE=${NOASSERT} MODULE=test.test_control_unit vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp
	! grep failure results.xml

test_glue_logic:
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -o sim_build/sim.vvp -s glue_logic -s dump -g2012 src/glue_logic.v test/dump_glue_logic.v
	PYTHONOPTIMIZE=${NOASSERT} MODULE=test.test_glue_logic vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp
	! grep failure results.xml

show_%: %.vcd %.gtkw
	gtkwave $^

# FPGA recipes

show_synth_%: src/%.v
	yosys -p "read_verilog $<; proc; opt; show -colors 2 -width -signed"

%.json: $(SOURCES)
	yosys -l fpga/yosys.log -p 'synth_ice40 -top rgb_mixer -json $(PROJECT).json' $(SOURCES)

%.asc: %.json $(ICEBREAKER_PIN_DEF) 
	nextpnr-ice40 -l fpga/nextpnr.log --seed $(SEED) --freq 20 --package $(ICEBREAKER_PACKAGE) --$(ICEBREAKER_DEVICE) --asc $@ --pcf $(ICEBREAKER_PIN_DEF) --json $<

%.bin: %.asc
	icepack $< $@


# general recipes

lint:
	verible-verilog-lint src/*v --rules_config verible.rules

clean:
	rm -rf *vcd sim_build fpga/*log fpga/*bin test/__pycache__

.PHONY: clean
