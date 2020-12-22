#!/bin/bash

device=$1
mkaArgument="${2:-bacon}"

showError()
{
	printf '\033[0;31m\nbuild.sh: Detected errors in a subfunction. Aborting...\n\033[0m'
	exit 1
}

printInfo()
{
	printf '\033[1;36m%s ' $1;
	printf '\033[0m\n';
}

if [ -z "$1" ]; then
    printInfo "Usage: buildLOS <device> [mka argument]"
    exit 0
fi

printInfo "Configuring some things..."
sudo mkdir /ccache-partition
sudo mount /dev/sdb6 /ccache-partition
sudo chown -R $USER /ccache-partition/*
export CCACHE_DIR=/ccache-partition/.ccache
export LC_ALL=C
export USE_CCACHE=1
#prebuilts/misc/linux-x86/ccache/ccache -M 42G

export ANDROID_JACK_VM_ARGS="-Xmx5G -Dfile.encoding=UTF-8 -XX:+TieredCompilation"
export JACK_SERVER_VM_ARGUMENTS=$ANDROID_JACK_VM_ARGS
./prebuilts/sdk/tools/jack-admin kill-server
./prebuilts/sdk/tools/jack-admin start-server

printInfo "Running environment setup..."
. build/envsetup.sh || showError
printf '\033[0;32m\nFinished environment setup successfully\n\n\033[0m'

printInfo "Lunching device..."
lunch lineage_$device-userdebug || showError
printf '\033[0;32m\nFinished lunch successfully\n\n\033[0m'

if [ "$mkaArgument" == "twrp" ]; then
	export RECOVERY_VARIANT=twrp
	mkaArgument=recoveryimage
elif [ "$mkaArgument" == "mmm" ]; then
	if [ -z "$1" ]; then
    		printInfo "Usage: buildLOS $1 mmm <directories>"
    		exit 0
	fi
	mmm $3 | tee build.log
	printInfo "Starting $3 build..."
	exit 0
fi

printInfo "Starting $mkaArgument build..."

mka $mkaArgument | tee build.log
