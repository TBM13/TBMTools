#!/bin/bash

zImage=./arch/arm/boot/zImage
zImageDtb=$zImage-dtb
path=~/Escritorio/Image_Kitchen_Custom
param=$1

exitErr()
{
	printf '\n';
	printf '\033[0;31m%s ' $1;
	printf '\033[0m\n';
	exit 1
}

printInfo()
{
	printf '\033[1;36m%s ' $1;
	printf '\033[0m\n';
}

if [ -f "./image-new.img" ]; then
	rm ./image-new.img
fi

num=0
for ext in img; do 
  files=( *."$ext" )
  num=$((num + ${#files[@]}))
done

if (( num > 1 )); then
    exitErr "Found multiple .img files"
fi

img=$(find -maxdepth 1 -name "*.img")

if [ -z "$img" ]; then
	exitErr ".img file not found"
fi

name=$(find -maxdepth 1 -name "*.img" -printf "%f\n")

if [ -z "$name" ]; then
	exitErr ".img file name not found"
fi

if [ -z "$path/unpackimg.sh $img" ]; then
	exitErr "unpackimg script not found"
fi

$path/unpackimg.sh $img || exitErr "Error while executing unpackimg.sh"

if [ ! -d "$path/split_img" ]; then
	exitErr "split_img folder not found after unpack attempt"
fi

printf '\n';

if [ -f "$path/split_img/$name-zImage" ]; then
	printInfo "Deleting split_img/$name-zImage"
	rm $path/split_img/$name-zImage
else
	printInfo "Warning: split_img/$name-zImage not found"
fi

if [ ! -f "$zImage" ]; then
	exitErr "Can't find $zImage"
fi

if [ -f "$zImageDtb" ]; then
	printInfo "Copying zImage-dtb..."
	cp $zImageDtb $path/split_img/$name-zImage-dtb
fi

printInfo "Copying zImage..."
cp $zImage $path/split_img/$name-zImage

if [ -z "$path/repackimg.sh" ]; then
	exitErr "repackimg script not found"
fi

printInfo "Repacking..."
$path/repackimg.sh || exitErr "Error while executing repackimg.sh"

if [ -z "$path/image-new.img" ]; then
	exitErr "Something went wrong ($path/image-new.img not found)"
fi

printInfo "Moving image-new.img"
mv $path/image-new.img ./

if [ -z "./image-new.img" ]; then
	exitErr "Something went wrong (./image-new.img not found)"
fi

printf '\033[0;32m\nFinished customRepack\n\n'
printf '\033[0m';

if [ -z "$param" ]; then
	exit 0
fi

if fastboot devices | grep -q 'fastboot'; then
	printf '\033[1;32m\nDetected device in fastboot mode\n\n'
	printf '\033[0m';
	printInfo "Flashing kernel..."
	fastboot flash boot ./image-new.img
	fastboot reboot
	exit 0
fi

if adb devices | grep -q 'recovery'; then
	printf '\033[1;32m\nDetected device in recovery mode\n\n'
	printf '\033[0m';
	printInfo "Pushing kernel to /sdcard..."
	adb push ./image-new.img /sdcard
fi
