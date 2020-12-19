#!/bin/bash
################################################################################
#
# The following script will work if you have petalinux 2020.1 and Vivado 2020.1
# in the path. And also the following 2 github repos both cloned in the same
# directory (which at least you must have pulled down the Microzed-PYNQ) to
# be reading this.
#
#   git clone --branch image_v2.6.0 https://github.com/Xilinx/PYNQ
#   git clone --branch image_v2.6.0 https://github.com/FredKellerman/Microzed7010-PYNQ
#
# After cloning make sure you have the correct branch and then run this script.
# Adjust file names and paths if you want to do something different.
#
################################################################################
BSP_FILE=microzed.bsp
ROOTFS_ZIP_FILE=pynq-rootfs-arm-2p6.zip
ROOTFS_IMAGE_FILE=bionic.arm.2.6.0_2020_10_19.img
IMAGE_FILE=microzed-2.6.0.img
OVERLAY_FILE_PATH=microzed/microzed
OVERLAY_NAME=microzed
START_DIR=$PWD
PYNQ_GIT_PATH="$START_DIR/../PYNQ"
MICROZED_BOARDDIR="$START_DIR"
BSP_FILE_PATH=microzed
BSP_FILE_URL=https://github.com/FredKellerman/Microzed7010-PYNQ/releases/download/v2.6.0
ROOTFS_IMAGE_FILE_URL=http://bit.ly/pynq_rootfs_arm_v2_6

echo "Status: Fetching pre-built rootfs for ARM 32"
if [ -f "$ROOTFS_ZIP_FILE" ]; then 
	echo "Status: $ROOTFS_ZIP_FILE -> already exists"
else
	wget "$ROOTFS_IMAGE_FILE_URL" -O "$ROOTFS_ZIP_FILE"
	unzip "$ROOTFS_ZIP_FILE"
fi

echo "Status: Fetching pre-built BSP"
if [ -f "$BSP_FILE_URL/$BSP_FILE" ]; then 
	echo "Status: $BSP_FILE -> already exists"
else
	wget "$BSP_FILE_URL/$BSP_FILE" -O "$BSP_FILE_PATH/$BSP_FILE"
fi

echo "Status: Building default Overlay"
if [ -f "$OVERLAY_FILE_PATH/$OVERLAY_NAME.bit" -a -f "$OVERLAY_FILE_PATH/$OVERLAY_NAME.hwh" ] ; then
	echo "Status: $OVERLAY_NAME -> .bit and .hwh already exists"
else
	cd "$OVERLAY_FILE_PATH"
	make clean
	make
	if [ -f "$OVERLAY_NAME.bit" -a -f "$OVERLAY_NAME.hwh" ] ; then
		echo "Status: Overlay build SUCCESS"
	else
		echo "Status: Overlay build FAILURE"
		exit 1
	fi
fi

echo "Status: Building PYNQ SD Image"
cd "$PYNQ_GIT_PATH/sdbuild"
make clean
make PREBUILT="$START_DIR/$ROOTFS_IMAGE_FILE" BOARDDIR="$MICROZED_BOARDDIR"

if [ -f "$PYNQ_GIT_PATH/sdbuild/output/$IMAGE_FILE" ] ; then
	cp "$PYNQ_GIT_PATH/sdbuild/output/$IMAGE_FILE" "$START_DIR/."
	echo "Status: Done building PYNQ image"
else
	echo "Status: Build FAILED"
fi

