#!/bin/sh

# Exit on any error
set -e

echo -e "\e[32m *** Be notified that you are building for ursa  ***"

# 5 seconds of countdown to allow user to check `PATH`
echo $PATH

for i in $(seq 5 -1 1); do
    echo -e "\e[32m *** Check your PATH variable, starting build in $i seconds... (Press Ctrl+C to abort) ***"
    sleep 1
done

# Set environment variables
echo -e "\e[34m *** Stage 1 - Setting environment variables... ***"
export LLVM=1    # Use Clang as compiler
export ARCH=arm64    # Set target architecture to ARM64
export SUBARCH=arm64    # Set target sub-architecture to ARM64
export CROSS_COMPILE=aarch64-linux-gnu-    # Set cross-compiler for ARM64
export CROSS_COMPILE_ARM32=arm-linux-gnueabihf-    # Set cross-compiler for ARM32
export LTO=thin    # Use Clang's ThinLTO for better performance and smaller binaries
echo -e "\e[0m "

# Clean the source tree and rename the log
echo -e "\e[34m *** Stage 2 - Cleaning the source tree and renaming the log... ***"
echo -e "\e[0m "
make mrproper
make O=out clean

if [ -e kernel_build.log ]; then
    mv kernel_build.log kernel_build.log.old
else
    touch kernel_build.log
fi



# Generate the default configuration for Xiaomi Mi 8 Explorer Edition (ursa)
echo -e "\e[34m *** Stage 3 - Generating default configuration for ursa... ***"
echo -e "\e[0m "
cat arch/arm64/configs/vendor/xiaomi/ursa.config \
    arch/arm64/configs/vendor/xiaomi/mi845_defconfig \
    > arch/arm64/configs/ursa_defconfig    # Merge configuration for ursa
make O=out ursa_defconfig


# Start the build process with all available threads
echo -e "\e[34m *** Stage 4 - Building kernel... ***"
echo -e "\e[0m "
make O=out -j$(nproc) | tee kernel_build.log


# Notify user of build completion
echo -e "\e[32m *** Completed with no errors, log saved to kernel_build.log ***"

# Reset environment variables
unset LLVM
unset ARCH
unset SUBARCH
unset CROSS_COMPILE
unset CROSS_COMPILE_ARM32
unset LTO

echo -e "\e[32m *** Environment variables unset ***"
echo -e "\e[0m "
