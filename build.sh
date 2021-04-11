#!/bin/bash

showError()
{
	printf '\033[0;31m\nbuild.sh: Detected errors in make: Aborting...\n\033[0m'
	exit 1
}

#arm:
arm_48=~/Desktop/Common/arm-eabi-4.8/bin/arm-eabi-
#arm64:
aarch64_linaro_650=~/Desktop/Common/gcc-linaro-6.5.0-2018.12-i686_aarch64-linux-gnu/bin/aarch64-linux-gnu-

export CROSS_COMPILE=$arm_48
export ARCH=arm
#export ANDROID_MAJOR_VERSION=q

make lineage_fame_defconfig || showError
printf '\033[0;32m\nDefconfig built successfully\n\n\033[0m'

make ARCH=$ARCH -j4 || showError
printf '\033[0;32m\nKernel Image built successfully\n\033[0m'

if [ -f "./customRepack.sh" ]; then
	./customRepack.sh $ARCH
fi
