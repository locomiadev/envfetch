#!/bin/sh
# envfetch v9 (Port for Plan9 systems)
# Run with "APE sh" (ape/sh) !

# Global variables
ENVFETCH_VER="v9"

# Main script
if grep -s 'vmx' /dev/drivers; then
	TOTAL=$(sed 1q /dev/swap | awk '{print int($1 / 1024 / 1024)}')
	USED=$(grep user /dev/swap | awk -F/ '{print int($1 * 4096 / 1024 / 1024)}')
	DE=$([ -e /dev/wsys ] && echo "rio" || echo "tty")
	echo
	echo "  ,-----,  $user@$sysname"
	echo " |   _   | os:       9front "
	echo " |  |_|  | ram:      $USED / $TOTAL MiB"
	echo " |  ._|  | cpu:      $(cat '#P/cputype')"
	echo "  '_____'  init:     9front init"
	echo "           shell:    ape/sh"
	echo "           de/wm:    $DE"
	echo "           envfetch: $ENVFETCH_VER"
else
	echo "You have an unsupported Plan9-based system. Please make an issue here: http://github.com/locomiadev/envfetch"
fi

