#!/bin/bash

zImage=./arch/arm/boot/zImage
zImageDtb=$zImage-dtb
path=~/Escritorio/Image_Kitchen_Custom
img=$(find -maxdepth 1 -name "*.img")

exitErr()
{
	printf '\n';
	printf '\033[0;31m%s ' $1;
	printf '\033[0m\n';
	exit 1
}

printInfo()
{
	printf '\033[0;36m%s ' $1;
	printf '\033[0m\n';
}

if [ -f "./image-new.img" ]; then
	rm ./image-new.img
fi

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

$path/unpackimg.sh $img

if [ ! -d "$path/split_img" ]; then
	exitErr "split_img folder not found after unpack attempt"
fi

if [ -f "$path/split_img/$name-zImage" ]; then
	printInfo "Deleting split_img/$name-zImage"
	rm $path/split_img/$name-zImage
else
	printInfo "Warning: split_img/$name-zImage not found"
fi

if [ ! -f "$zImage" ]; then
	exitErr "Cant find $zImage"
fi

if [ -f "$zImageDtb" ]; then
	printInfo "Found $zImageDtb"
	printInfo "Copying zImage-dtb..."
	cp $zImageDtb $path/split_img/$name-zImage-dtb
fi

printInfo "Copying zImage..."
cp $zImage $path/split_img/$name-zImage

if [ -z "$path/repackimg.sh" ]; then
	exitErr "repackimg script not found"
fi

printInfo "Repacking..."
$path/repackimg.sh

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

if fastboot devices | grep -q 'fastboot'; then
	printf '\033[1;32m\nDevice in fastboot mode detected\n\n'
	printf '\033[0m';
	printInfo "Flashing kernel..."
	fastboot flash boot ./image-new.img
	fastboot reboot
fi
