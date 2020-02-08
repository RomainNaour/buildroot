#!/bin/bash

BOARD_DIR="$(dirname $0)"
DEFCONFIG_NAME="$(basename $2)"
README_FILE="${BOARD_DIR}/readme.txt"
START_QEMU_SCRIPT="${BINARIES_DIR}/start-qemu.sh"

# if [[ "${f}" =~ ^"${ignore}" ]]; then
if [[ "${DEFCONFIG_NAME}" =~ ^"qemu_*" ]]; then
    # Not a Qemu defconfig, can't test.
    return
fi

if [ -f $README_FILE ]; then
    QEMU_CMD_LINE=$(cat $README_FILE | sed -r "/^${DEFCONFIG_NAME}: /!d; :a; /\\$/N; s/\\\n//; ta; s/^[^:]+://")
    QEMU_CMD_LINE=${QEMU_CMD_LINE//output\/images/\${IMAGE_DIR\}}
    # Test if we are running in gitlab
    if [ -n "$CI_JOB_NAME" ]; then
        # Remove -serial stdio if present
        QEMU_CMD_LINE=${QEMU_CMD_LINE//-serial stdio/}
        # Disable graphical output and redirect serial I/Os to console
        # Special case for SH4
        QEMU_CMD_LINE="$QEMU_CMD_LINE -serial stdio -display none"
    fi
    cat << EOF > $START_QEMU_SCRIPT
#!/bin/sh
IMAGE_DIR="\$(dirname \$0)"

$QEMU_CMD_LINE
EOF
    chmod +x $START_QEMU_SCRIPT
fi
