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

# BOARD_TYPE can be either 7010 or 7020
BOARD_TYPE=7020
#BOARD_TYPE=7010

BSP_FILE=microzed.bsp
BSP_FILE_PATH=mz-$BOARD_TYPE/microzed-$BOARD_TYPE
BSP_FILE_URL=https://github.com/FredKellerman/Microzed-PYNQ/releases/download/v2.6.0
ROOTFS_TMP_DIR=rootfs_tmp
ROOTFS_ZIP_FILE=pynq-rootfs-arm-2p6.zip
ROOTFS_IMAGE_FILE=bionic.arm.2.6.0_2020_10_19.img
ROOTFS_IMAGE_FILE_URL=https://github.com/FredKellerman/Microzed-PYNQ/releases/download/v2.6.0
SD_IMAGE_FILE=microzed-$BOARD_TYPE-2.6.0.img
OVERLAY_FILE_PATH=mz-$BOARD_TYPE/microzed-$BOARD_TYPE/base_overlay
OVERLAY_NAME=microzed_base_overlay
START_DIR=$PWD
PYNQ_GIT_LOCAL_PATH="$START_DIR/PYNQ-git"
#PYNQ_GIT_BRANCH="image_v2.7.0"
PYNQ_GIT_BRANCH="image_v2.7"
MICROZED_BOARDDIR="$START_DIR/mz-$BOARD_TYPE"
#GIT_REPO_URL="https://github.com/Xilinx/PYNQ"
GIT_REPO_URL="https://github.com/schelleg/PYNQ"

##################################
# Fetching and compiling         #
##################################

echo "Status: creating dir for rootfs"
mkdir $ROOTFS_TMP_DIR

echo "Status: Fetching PYNQ git $PYNQ_GIT_LOCAL_PATH"
if [ -d "$PYNQ_GIT_LOCAL_PATH" ]; then
	echo "Status: PYNQ repo -> already cloned $PYNQ_GIT_LOCAL_PATH"
else
	git clone --branch $PYNQ_GIT_BRANCH $GIT_REPO_URL $PYNQ_GIT_LOCAL_PATH
	echo "Status: PYNQ repo cloned to branch: $PYNQ_GIT_BRANCH"
fi

echo "Status: Fetching pre-built rootfs for ARM 32"
if [ -f "$ROOTFS_TMP_DIR/$ROOTFS_IMAGE_FILE" ]; then 
	echo "Status: image file $ROOTFS_TMP_DIR/$ROOTFS_IMAGE_FILE -> already exists"
else
	if [ -f "$ROOTFS_TMP_DIR/$ROOTFS_ZIP_FILE" ]; then
		echo "Status: zip file -> already exists"
	else
		wget "$ROOTFS_IMAGE_FILE_URL/$ROOTFS_ZIP_FILE" -O "$ROOTFS_TMP_DIR/$ROOTFS_ZIP_FILE"
	fi
	fsize=$(wc -c <"$ROOTFS_TMP_DIR/$ROOTFS_ZIP_FILE")
	echo $fsize
	if [ $fsize -gt "0" ]; then
		unzip "$ROOTFS_TMP_DIR/$ROOTFS_ZIP_FILE" -d "$ROOTFS_TMP_DIR"
	else
		rm "$ROOTFS_TMP_DIR/$ROOTFS_ZIP_FILE"
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
make PREBUILT="$START_DIR/$ROOTFS_TMP_DIR/$ROOTFS_IMAGE_FILE" BOARDDIR="$MICROZED_BOARDDIR"

if [ -f "$PYNQ_GIT_LOCAL_PATH/sdbuild/output/$SD_IMAGE_FILE" ]; then
	cp "$PYNQ_GIT_LOCAL_PATH/sdbuild/output/$SD_IMAGE_FILE" "$START_DIR/."
	echo "Status: Done building PYNQ image"
else
	echo "Status: Build FAILED"
	exit -1
fi

exit 0
