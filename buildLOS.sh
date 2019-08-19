#!/bin/bash

param=$1

showError()
{
	printf '\033[0;31m\nbuild.sh: Detected errors in a subfunction. Aborting...\n'
	printf '\033[0m';
	exit 1
}

printInfo()
{
	printf '\033[1;36m%s ' $1;
	printf '\033[0m\n';
}

printInfo "Configuring some things..."
export LC_ALL=C
export CCACHE_DIR=./.ccache
export USE_CCACHE=1
export CCACHE_COMPRESS=1
prebuilts/misc/linux-x86/ccache/ccache -M 50G

export ANDROID_JACK_VM_ARGS="-Xmx4096m -Xms512m -Dfile.encoding=UTF-8 -XX:+TieredCompilation"
./prebuilts/sdk/tools/jack-admin kill-server
./prebuilts/sdk/tools/jack-admin start-server

printInfo "Running environment setup..."
. build/envsetup.sh || showError

printf '\033[0;32m\nFinished environment setup successfully\n\n'
printf '\033[0m';

printInfo "Lunching device..."
lunch lineage_j2lte-userdebug || showError

printf '\033[0;32m\nFinished lunch successfully\n\n'
printf '\033[0m';

printf '\033[0;32m\nDefconfig built successfully\n\n'
printf '\033[0m';

if [ -z "$param" ]; then
	printInfo "Starting build..."
	mka bacon | tee build.log
else
	printInfo "Starting custom build..."
	mka $param | tee build.log
fi
