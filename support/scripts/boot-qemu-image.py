#!/usr/bin/env python3

# This script expect to run from the Buildroot top directory.

import pexpect
import sys
import os
import re
import shlex
import shutil
import subprocess

argc = len(sys.argv)
if not (argc == 2):
    print("Error: incorrect number of arguments")
    print("""Usage: boot-qemu-image.py <qemu_arch_defconfig>""")
    sys.exit(1)

defconfig_filename = sys.argv[1]

# Ignore non Qemu defconfig
if defconfig_filename.startswith('qemu_') is False:
    sys.exit(0)

qemu_start_script_filepath = os.path.join(os.getcwd(), 'output/images/start-qemu.sh')

qemu_cmd = ""

with open(qemu_start_script_filepath, 'r') as script_file:
    for line in script_file:
        if re.search("qemu-system", line):
            qemu_cmd = line
            break

if not qemu_cmd:
    print("Error: No QEMU command line found in " + qemu_start_script_filepath)
    sys.exit(1)

# Replace bashism
qemu_cmd = line.replace("${IMAGE_DIR}", "output/images")

# pexpect needs a list, convert a sting to a list and escape quoted substring.
qemu_cmd = shlex.split(qemu_cmd)

# Use host Qemu if provided by Buildroot.
os.environ["PATH"] = os.getcwd() + "/output/host/bin" + os.pathsep + os.environ["PATH"]

# Ignore when no Qemu emulation is available
if not shutil.which(qemu_cmd[0]):
    print("No " + qemu_cmd[0] + " binary available, THIS DEFCONFIG CAN NOT BE TESTED!")
    sys.exit(0)


def main():
    global child

    try:
        child.expect(["buildroot login:", pexpect.TIMEOUT], timeout=60)
    except pexpect.EOF:
        print("Connection problem, exiting.")
        sys.exit(1)
    except pexpect.TIMEOUT:
        print("System did not boot in time, exiting.")
        sys.exit(1)

    child.sendline("root\r")

    try:
        child.expect(["# ", pexpect.TIMEOUT], timeout=60)
    except pexpect.EOF:
        print("Cannot connect to shell")
        sys.exit(1)
    except pexpect.TIMEOUT:
        print("Timeout while waiting for shell")
        sys.exit(1)

    child.sendline("poweroff\r")

    try:
        child.expect(["System halted", pexpect.TIMEOUT], timeout=60)
        child.expect(pexpect.EOF)
    except pexpect.EOF:
        sys.exit(0)
    except pexpect.TIMEOUT:
        print("Cannot halt machine")
        # Qemu may not exit properly after "System halted", ignore.
        sys.exit(0)


# Log the Qemu version
subprocess.call([qemu_cmd[0], "--version"])

# Log the Qemu command line
print(qemu_cmd)

child = pexpect.spawn(qemu_cmd[0], qemu_cmd[1:], timeout=5, encoding='utf-8',
                      env={"QEMU_AUDIO_DRV": "none", 'PATH': os.environ["PATH"]})
# We want only stdout into the log to avoid double echo
child.logfile = sys.stdout
main()
