#!/bin/bash

showError()
{
	printf '\033[0;31m\nbuild.sh: Detected errors in make: Aborting...\n'
	printf '\033[0m';
	exit 1
}

export CROSS_COMPILE=~/Escritorio/toolchains/arm-eabi-4.8/bin/arm-eabi-
export ARCH=arm

make lineage_fame_defconfig || showError

printf '\033[0;32m\nDefconfig built successfully\n\n'
printf '\033[0m';

make ARCH=arm -j4 || showError

printf '\033[0;32m\nzImage built successfully\n'
printf '\033[0m';

if [ -f "./customRepack.sh" ]; then
	./customRepack.sh 1
fi
