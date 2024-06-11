#!/usr/bin/env bash
echo "Setup env"
sudo apt update -y
sudo apt install -y bc flex bison cpio gcc-aarch64* gcc-arm* python-is-python3 binutils coreutils build-essential
echo "Cloning dependencies"
git clone --depth=1 https://github.com/kdrag0n/proton-clang clang
rm -rf AnyKernel
git clone --depth=1 https://github.com/sohamxda7/AnyKernel3 AnyKernel
echo "Done"
IMAGE=$(pwd)/out/arch/arm64/boot/Image.gz-dtb
TANGGAL=$(date +"%F-%S")
START=$(date +"%s")
export CONFIG_PATH=$PWD/arch/arm64/configs/lavender-perf_defconfig
PATH="${PWD}/clang/bin:$PATH"
export ARCH=arm64
export KBUILD_BUILD_HOST=Kaze
export KBUILD_BUILD_USER="kenichi"
# Compile plox
function compile() {
   make O=out ARCH=arm64 lavender-perf_defconfig
       make -j$(nproc --all) O=out \
                             ARCH=arm64 \
			     CC=clang \
			     CROSS_COMPILE=aarch64-linux-gnu- \
			     CROSS_COMPILE_ARM32=arm-linux-gnueabi-
   cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
}
# Zipping
function zipping() {
    cd AnyKernel || exit 1
    zip -r9 4.4-lavender_Nyaa-${TANGGAL}.zip *
    curl bashupload.com -T *.zip
    cd ..
}
compile
zipping
END=$(date +"%s")
DIFF=$(($END - $START))
