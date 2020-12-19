overlay_name := microzed
design_name := microzed

all: block_design bitstream check_timing
	@echo
	@tput setaf 2 ; echo "Built $(overlay_name) successfully!"; tput sgr0;
	@echo

block_design:
	vivado -mode batch -source $(overlay_name).tcl -notrace

bitstream:
	vivado -mode batch -source build_bitstream.tcl -notrace

check_timing:
	vivado -mode batch -source check_timing.tcl -notrace

clean:
	rm -rf $(overlay_name) *.jou *.log NA .Xil $(overlay_name).xsa $(overlay_name).bit $(overlay_name).hwh
