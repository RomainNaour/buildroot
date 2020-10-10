#!/bin/bash

# This script must be run under fakeroot.

TARGET_DIR=$1

gnu_set_server () {
  SERVER=$1
  OWNER=$2
  PERMS=$3
  VALUE=$4
  cd ${TARGET_DIR}/servers
  if [ ! -e $SERVER ] ; then
    touch $SERVER
    chown $OWNER:$OWNER $SERVER
    chmod $PERMS $SERVER
    setfattr -n gnu.translator -v "$VALUE" $SERVER
  fi
}

gnu_set_dev () {
  DEV_NODE=$1
  OWNER=$2
  PERMS=$3
  VALUE=$4 
  cd ${TARGET_DIR}/dev
  if [ ! -e $DEV_NODE ] ; then
    touch $DEV_NODE
    chown $OWNER:$OWNER $DEV_NODE
    chmod $PERMS $DEV_NODE
    setfattr -n gnu.translator -v "$VALUE" $DEV_NODE
    if [ $DEV_NODE = "fd" ] ; then
      ln -f -s fd/0 stdin
      ln -f -s fd/1 stdout
      ln -f -s fd/2 stderr
    fi
  fi  
}

gnu_setup_passive_translators () {
  if [ ! -e ${TARGET_DIR}/servers/exec ] ; then
    return 2
  else
    setfattr -n gnu.translator -v "/hurd/exec\0" ${TARGET_DIR}/servers/exec 2> /dev/null || return 1
  fi
  echo "Setting up passive translators..."
  # This must come before evaluating `uname -s` because, on GNU,
  # without the pflocal server set as a translator on
  # /servers/socket/1, pipes cannot be created.
  gnu_set_server socket/1 root 666 "/hurd/pflocal\0"
  gnu_set_server socket/2 root 666 "/hurd/pfinet\0"
  gnu_set_server crash-suspend root 666 "/hurd/crash\0--suspend\0"
  gnu_set_server crash-dump-core root 666 "/hurd/crash\0--dump-core\0"
  gnu_set_server crash-kill root 666 "/hurd/crash\0--kill\0"
  gnu_set_server password root 666 "/hurd/password\0"
  gnu_set_server default-pager root 666 "/hurd/proxy-defpager\0"
  chmod +x ${TARGET_DIR}/servers/default-pager

  if [ ! -e ${TARGET_DIR}/servers/crash ] ; then
    ln -s crash-suspend ${TARGET_DIR}/servers/crash
  fi
  if [ ! -e ${TARGET_DIR}/servers/socket/local ] ; then
    ln -s 1 ${TARGET_DIR}/servers/socket/local
  fi
  if [ ! -e ${TARGET_DIR}/servers/socket/inet ] ; then
    ln -s 2 ${TARGET_DIR}/servers/socket/inet
  fi
  
  # MAKEDEV std: mkdev console tty random urandom null zero full fd time mem klog shm
  gnu_set_dev fd root 666 "/hurd/magic\0--directory\0fd\0"
  gnu_set_dev tty root 666 "/hurd/magic\0tty\0"
  gnu_set_dev null root 666 "/hurd/null\0"
  gnu_set_dev zero root 666 "/bin/nullauth\0--\0/hurd/storeio\0-Tzero\0"
  gnu_set_dev full root 666 "/hurd/null\0--full\0"
  gnu_set_dev time root 644 "/hurd/storeio\0--no-cache\0time\0"
  gnu_set_dev mem root 660 "/hurd/storeio\0--no-cache\0mem\0"
  gnu_set_dev klog root 660 "/hurd/streamio\0kmsg\0"

  # /dev/shm is used by the POSIX.1 shm_open call in libc.
  # We don't want the underlying node to be written by randoms,
  # but the filesystem presented should be writable by anyone
  # and have the sticky bit set so others' files can't be removed.
  # tmpfs requires an arbitrary size limitation here.  To be like
  # Linux, we tell tmpfs to set the size to half the physical RAM
  # in the machine.
  gnu_set_dev shm root 644 "/hurd/tmpfs\0--mode=1777\00050%\0"

  gnu_set_dev hd0 root 640 "/hurd/storeio\0hd0\0"
  for I in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16; do
    gnu_set_dev hd0s$I root 640 "/hurd/storeio\0hd0s$I\0"
  done

  for J in 0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v; do
    gnu_set_dev ptyp$J root 666 "/hurd/term\0/dev/ptyp$J\0pty-master\0/dev/ttyp$J\0"
    gnu_set_dev ttyp$J root 666 "/hurd/term\0/dev/ttyp$J\0pty-slave\0/dev/ptyp$J\0"
  done
  for J in 0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v; do
    gnu_set_dev ptyq$J root 666 "/hurd/term\0/dev/ptyq$J\0pty-master\0/dev/ttyq$J\0"
    gnu_set_dev ttyq$J root 666 "/hurd/term\0/dev/ttyq$J\0pty-slave\0/dev/ptyq$J\0"
  done
  gnu_set_dev vcs root 600 "/hurd/console\0"

  for I in 1 2 3 4 5 6; do
    gnu_set_dev tty$I root 600 "/hurd/term\0/dev/tty$I\0hurdio\0/dev/vcs/$I/console\0"
  done

  gnu_set_dev cd0 root 640 "/hurd/storeio\0cd0\0"
  gnu_set_dev cd1 root 640 "/hurd/storeio\0cd1\0"

  for I in 1 2 3; do
    gnu_set_dev com$I root 600 "/hurd/term\0/dev/com$I\0device\0com$I\0"
  done

  for I in 1 2 3; do
    gnu_set_dev eth$I root 660 "/hurd/devnode\0-M\0/dev/netdde\0eth$I\0"
  done

  # In Linux an inactive "/dev/loopN" device acts like /dev/null.
  # The `losetup' script changes the translator to "activate" the device.
  for I in 0 1 2 3 4 5 6 7; do
    gnu_set_dev loop$I root 640 "/hurd/null\0"
  done

  for I in 0 1 2; do
    gnu_set_dev lpr$I root 660 "/hurd/streamio\0lpr$I\0"
  done

  gnu_set_dev netdde root 660 "/hurd/netdde\0"

}

#####################################
# create passive translators
#####################################
gnu_setup_passive_translators
