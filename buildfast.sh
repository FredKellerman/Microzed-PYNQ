#!/bin/bash
################################################################################
#
# The following script should work if you have petalinux 2020.1 and Vivado
# 2020.1 in the path.  A few very common utilities are also used.  This will
# build PYNQ v2.6
#
# Adjust file names and paths of shell variables if needed.
#
################################################################################

##################################
# Various path and file settings #
##################################

BSP_FILE=microzed.bsp
ROOTFS_ZIP_FILE=pynq-rootfs-arm-2p6.zip
ROOTFS_IMAGE_FILE=bionic.arm.2.6.0_2020_10_19.img
IMAGE_FILE=microzed-2.6.0.img
OVERLAY_FILE_PATH=base-overlay/microzed_base_overlay
OVERLAY_NAME=microzed_base_overlay
START_DIR=$PWD
PYNQ_GIT_LOCAL_PATH="$START_DIR/PYNQ"
GIT_BRANCH="image_v2.6.0"
MICROZED_BOARDDIR="$START_DIR"
BSP_FILE_PATH=microzed
BSP_FILE_URL=https://github.com/FredKellerman/Microzed7010-PYNQ/releases/download/v2.6.0
ROOTFS_IMAGE_FILE_URL=https://github.com/FredKellerman/Microzed7010-PYNQ/releases/download/v2.6.0

##################################
# Fetching and compiling         #
##################################

echo "Status: Fetching PYNQ git $PYNQ_GIT_LOCAL_PATH"
if [ -d "$PYNQ_GIT_LOCAL_PATH" ]; then
	echo "Status: PYNQ repo -> already cloned $PYNQ_GIT_LOCAL_PATH"
else
	git clone --branch $GIT_BRANCH https://github.com/Xilinx/PYNQ $PYNQ_GIT_LOCAL_PATH
	echo "Status: PYNQ repo cloned to branch: $GIT_BRANCH"
fi

echo "Status: Fetching pre-built rootfs for ARM 32"
if [ -f "$ROOTFS_IMAGE_FILE" ]; then 
	echo "Status: $ROOTFS_IMAGE_FILE -> already exists"
else
	if [ -f "$ROOTFS_ZIP_FILE" ]; then
		echo "Status: zip file -> already exists"
	else
		wget "$ROOTFS_IMAGE_FILE_URL/$ROOTFS_ZIP_FILE" -O "$ROOTFS_ZIP_FILE"
	fi
	fsize=$(wc -c <"$ROOTFS_ZIP_FILE")
	if [ $fsize -gt "0" ]; then
		unzip "$ROOTFS_ZIP_FILE"
	else
		rm $ROOTFS_ZIP_FILE
		echo "Error: Failed to fetch rootfs zip file!"
		exit -1
	fi
fi

echo "Status: Fetching pre-built BSP"
if [ -f "$BSP_FILE_PATH/$BSP_FILE" ]; then 
	echo "Status: $BSP_FILE -> already exists"
else
	wget "$BSP_FILE_URL/$BSP_FILE" -O "$BSP_FILE_PATH/$BSP_FILE"
	fsize=$(wc -c <"$BSP_FILE_PATH/$BSP_FILE")
	if [ $fsize -eq "0" ]; then
		rm "$BSP_FILE_PATH/$BSP_FILE"
		echo "Error: Failed to fetch bsp file!"
		exit -1
	fi
fi

echo "Status: Building default Overlay"
if [ -f "$OVERLAY_FILE_PATH/$OVERLAY_NAME.bit" -a -f "$OVERLAY_FILE_PATH/$OVERLAY_NAME.hwh" ] ; then
	echo "Status: $OVERLAY_NAME -> .bit and .hwh already exists"
else
	cd "$OVERLAY_FILE_PATH"
	make clean
	make
	if [ -f "$OVERLAY_NAME.bit" -a -f "$OVERLAY_NAME.hwh" ]; then
		echo "Status: Overlay build SUCCESS"
	else
		echo "Status: Overlay build FAILURE"
		exit -1
	fi
fi

echo "Status: Building PYNQ SD Image"
cd "$PYNQ_GIT_LOCAL_PATH/sdbuild"
make clean
make PREBUILT="$START_DIR/$ROOTFS_IMAGE_FILE" BOARDDIR="$MICROZED_BOARDDIR"

if [ -f "$PYNQ_GIT_LOCAL_PATH/sdbuild/output/$IMAGE_FILE" ]; then
	cp "$PYNQ_GIT_LOCAL_PATH/sdbuild/output/$IMAGE_FILE" "$START_DIR/."
	echo "Status: Done building PYNQ image"
else
	echo "Status: Build FAILED"
	exit -1
fi

exit 0
