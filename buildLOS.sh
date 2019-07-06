#!/bin/bash

showError()
{
	printf '\033[0;31m\nbuild.sh: Detected errors in make: Aborting...\n'
	printf '\033[0m';
	exit 1
}

echo Setting some things...
export LC_ALL=C
export CCACHE_DIR=./.ccache
export USE_CCACHE=1
export CCACHE_COMPRESS=1
prebuilts/misc/linux-x86/ccache/ccache -M 70G

export ANDROID_JACK_VM_ARGS="-Xmx4096m -Xms512m -Dfile.encoding=UTF-8 -XX:+TieredCompilation"
./prebuilts/sdk/tools/jack-admin kill-server
./prebuilts/sdk/tools/jack-admin start-server

echo Setting environment...
. build/envsetup.sh || showError

echo Lunching device...
lunch lineage_j2lte-userdebug || showError
printf '\033[0;32m\nDefconfig built successfully\n\n'
printf '\033[0m';

echo Starting build...
mka bacon | tee build.log
