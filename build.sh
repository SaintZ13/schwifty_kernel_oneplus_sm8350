#!/bin/bash

# Kernel version configuration
KNAME="SchwiftyKernel-OP9PRO"
MIN_HEAD=$(git rev-parse HEAD)
VERSION="$(cat version)-$(date +%m.%d.%y)-$(echo ${MIN_HEAD:0:8})"
ZIPNAME="${KNAME}-$(cat version)-$(echo ${MIN_HEAD:0:8})"
kernel_dir="${PWD}"
CCACHE=$(command -v ccache)
HOME=/home/saintz
objdir="${kernel_dir}/out"
anykernel=$HOME/AnyKernel3

export LOCALVERSION="-${KNAME}-$(echo "${VERSION}")"

# Start Timer
START=$(date +"%s")
./source.sh

cd "${objdir}"
COMPILED_IMAGE=arch/arm64/boot/Image
COMPILED_DTBO=arch/arm64/boot/dtbo.img
mv -f ${COMPILED_IMAGE} ${COMPILED_DTBO} $anykernel
find arch/arm64/boot/dts -name '*.dtb' -exec cat {} + > $anykernel/dtb
cd $anykernel
find . -name "*.zip" -type f
find . -name "*.zip" -type f -delete
zip -r AnyKernel.zip * || exit 1

# End Timer
END=$(date +"%s")
DIFF=$((END - START))
echo -e "Kernel compiled successfully in $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s)"