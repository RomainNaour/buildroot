#!/bin/bash

QEMU_BOARD_DIR="$(dirname $0)"
DEFCONFIG_NAME="$(basename $2)"
README_FILES="${QEMU_BOARD_DIR}/*/readme.txt"
START_QEMU_SCRIPT="${BINARIES_DIR}/start-qemu.sh"

if [[ "${DEFCONFIG_NAME}" =~ ^"qemu_*" ]]; then
    # Not a Qemu defconfig, can't test.
    exit 0
fi

# Search for "# qemu_*_defconfig" tag in all readme.txt files.
# Qemu command line on multilines using back slash are accepted.
QEMU_CMD_LINE=$(sed -r ':a; /\\$/N; s/\\\n//; s/\t/ /; ta; /# '${DEFCONFIG_NAME}'$/!d; s/#.*//' ${README_FILES})

if [ -z "$QEMU_CMD_LINE" ]; then
    # No Qemu cmd line found, can't test.
    exit 0
fi

# Replace output/images path by ${IMAGE_DIR} since the script
# will be in the same directory as the kernel and the rootfs images.
QEMU_CMD_LINE=${QEMU_CMD_LINE//output\/images/\${IMAGE_DIR\}}

# Test if we are running in gitlab
if [ -n "$CI_JOB_NAME" ]; then
    # Remove -serial stdio if present
    QEMU_CMD_LINE=${QEMU_CMD_LINE//-serial stdio/}

    # Disable graphical output and redirect serial I/Os to console
    case ${DEFCONFIG_NAME} in
        # Special case for SH4
        qemu_sh4eb_r2d_defconfig | qemu_sh4_r2d_defconfig)
            QEMU_CMD_LINE="$QEMU_CMD_LINE -serial stdio -display none"
            ;;
        *)
            QEMU_CMD_LINE="$QEMU_CMD_LINE -nographic"
            ;;
    esac
fi

cat << EOF > $START_QEMU_SCRIPT
#!/bin/sh
IMAGE_DIR="\$(dirname \$0)"

$QEMU_CMD_LINE
EOF

chmod +x $START_QEMU_SCRIPT
