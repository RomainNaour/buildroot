#!/bin/sh

set -e

BOARD_DIR=$(dirname "$0")

cp -f "$BOARD_DIR/grub-bios.cfg" "$TARGET_DIR/boot/grub/grub.cfg"

# Copy grub 1st stage to binaries, required for genimage
cp -f "$HOST_DIR/lib/grub/i386-pc/boot.img" "$BINARIES_DIR"

##############################
# Prepare initial translator.
##############################
mkdir -p "$TARGET_DIR/servers/socket"
touch "$TARGET_DIR/servers/exec"

# remove symlink from Buildroot skeleton
if [ -L $TARGET_DIR/dev/fd ] ; then
  rm -f $TARGET_DIR/dev/fd
fi
mkdir -p $TARGET_DIR/dev/fd

dd if=/dev/zero of=$BINARIES_DIR/rootfs.swap bs=512M count=1

# Create a swap image
${HOST_DIR}/sbin/mkswap -L swap $BINARIES_DIR/rootfs.swap
