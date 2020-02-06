#!/bin/bash

BOARD_DIR="$(dirname $0)"
README_FILE="${BOARD_DIR}/readme.txt"
START_QEMU_SCRIPT="${BINARIES_DIR}/start-qemu.sh"

if [ -f $README_FILE ]; then
    DEFCONFIG_NAME=$(cat $README_FILE | sed -r '/^.*: /!d; :a; /\\$/N; ta; s/:.*$//')
    QEMU_CMD_LINE=$(cat $README_FILE | sed -r "/^${DEFCONFIG_NAME}: /!d; :a; /\\$/N; s/\\\n//; ta; s/^[^:]+://")
    QEMU_CMD_LINE=${QEMU_CMD_LINE//output\/images/\${IMAGE_DIR\}}
    cat << EOF > $START_QEMU_SCRIPT
#!/bin/sh
IMAGE_DIR="\$(dirname \$0)"

$QEMU_CMD_LINE
EOF
    chmod +x $START_QEMU_SCRIPT
fi
