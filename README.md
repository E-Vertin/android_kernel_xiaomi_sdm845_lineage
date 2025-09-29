# LineageOS Kernel Source Code for Xiaomi Mi 8 series with Qualcomm Snapdragon 845 (SDM845)

**PLEASE NOTE THAT THE ORIGINAL `README` WAS RENAMED AS `README.old`**

> [!IMPORTANT] Disclaimer
>
> - I am **NOT** responsible for bricked devices, dead SD cards, thermonuclear war, or you getting fired because the alarm app failed.
>
> - Please do some research if you have any concerns about it before flashing anything!
>
> - **YOU** are choosing to make these modifications; I AM NOT RESPONSIBLE for any consequences.

## My purpose of creating this fork

- Add a `build.sh` to automate the building process for Xiaomi Mi 8

- Add a new `README` to help those who want to build their own kernel from source

## Prerequisites

- 1. A GNU/Linux operating system (I am using Gentoo Linux) and your advanced knowledge of it

- 2. The corresponding phone that have the latest LineageOS installed

- 3. The toolchain for cross-compiling (in this case, we need `aarch64-linux-gnu` for 64-bit and `arm-linux-gnueabihf` for 32-bit)

- 4. **Your capability** to recover your phone to a working state if **you have it bricked**

## Reminder

- This copy of the kernel source code is provided by LineageOS and **MAY** only work with the latest LineageOS build of the corresponding phone

## Known errors of this repository

- On my Gentoo Linux, with `CROSS_COMPILE` and `CROSS_COMPILE_ARM32` set and `LLVM=1` though, the assembler and linker will still fall back to `/usr/bin/as` and `/usr/bin/ld` which are symbolic links that points to the respective tool aiming at `x86_64-pc-linux-gnu`.
  
  Replacing them to point to `arm-linux-gnueabihf-as` and `arm-linux-gnueabihf-ld` temporarily is a workaround for me.

- `net/netfilter/xt_TCPMSS.o` might report an error of `No rule to make`, this could be a case-sensitive issue.

  I duplicated `net/netfilter/xt_tcpmss.c` as `net/netfilter/xt_TCPMSS.c` to have this passed.

## Instrcutions to build

- 1. Install all dependencies and necessary toolchain from your distro's software repository

    - For Gentoo Linux, you will need to follow the [instructions](https://wiki.gentoo.org/wiki/Crossdev) of using `sys-devel/crossdev` to build the toolchain

    - For Debian-based distros such as Ubuntu, you can refer to related guides to install all essential packages

    - For Arch-based distros, you might already know what to do  :)

- 2. Download or clone this copy of the kernel source code

- 3. Start to build

    - Manual approach

        - 1. Navigate to the top-level directory of the kernel source
        
        - 2. Set environment variables for the toolchain
  
            ```bash
            export LLVM=1    # Use Clang as the compiler
            export ARCH=arm64    # Set target architecture to ARM 64-bit
            export SUBARCH=arm64     # Set target sub-architecture to ARM 64-bit
            export LTO=thin    # Use ThinLTO for better performance and smaller binary size
            export CROSS_COMPILE=aarch64-linux-gnu-   # Set the cross-compiler for ARM64
            export CROSS_COMPILE_ARM32=arm-linux-gnueabihf-   # Set the cross-compiler for ARM32
            ```

            > Make sure you have the toolchain added to your `PATH`

        - 3. Merge and generate the default configuration file for your device

            ```bash
            cat arch/arm64/configs/vendor/xiaomi/<codename>.config \
                arch/arm64/configs/vendor/xiaomi/mi845_defconfig \
                > arch/arm64/configs/<codename>_defconfig    # Merge configuration
            make O=out <codename>_defconfig    # Generate the default configuration file in `out`
            ```

            > Note that all default configuration files are located in `arch/arm64/configs/`

            > Xiaomi's configurations are in `arch/arm64/configs/vendor/xiaomi/`

        - 4. Start the compilation
        
            ```bash
            make O=out -j$(nproc)    # Compile the kernel with all available threads
            ```
        
        - 5. If no error generated, the kernel image and dtb will be available in `out/arch/arm64/boot/`
        
        - 6. Proceed to pack the kernel via `AnyKernel3` or other methods like `mkbootimg` if you prefer and flash it to your device to test

    - Automated approach (via `build.sh`)

      > Feel free to modify the given `build.sh` to suit your device and environment
    
        - 1. Navigate to the top-level directory of the kernel source
        
        - 2. Make sure `build.sh` is executable
        
            > If not, run `chmod +x build.sh` to make it executable

        - 3. Execute `build.sh` to start
        
        - 4. --- THE SAME ABOVE ---

## Integration of KernelSU and its derivatives

Their developers have done an excellent job on composing the self-explanatory documentation, refer to their respective GitHub repositories for more information.
