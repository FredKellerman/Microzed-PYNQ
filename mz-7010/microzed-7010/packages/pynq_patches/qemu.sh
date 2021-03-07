#!/bin/bash

set -e
set -x

# Adjust pynq python library source for MicroZed base clock rate
cd /home/xilinx
patch pynq/ps.py ./clock_rate.patch

# Clean-up patch file
rm ./clock_rate.patch
