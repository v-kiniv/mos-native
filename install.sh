INSTALL_PATH=$PWD
MOS_VERSION=2.18.0
DOCKER_TAG=3.3-r5
TOOLCHAIN_VERSION=1.22.0-96-g2852398-5.2.0

echo $'\e[36mInstalling ESP-IDF...\e[0m'
rm -rf $INSTALL_PATH/esp-idf
git clone --depth=1 --recursive --branch $DOCKER_TAG https://github.com/mongoose-os/esp-idf $INSTALL_PATH/esp-idf
sh $INSTALL_PATH/esp-idf/install.sh
make -C $INSTALL_PATH/esp-idf/tools/kconfig conf-idf mconf-idf

echo $'\e[36mInstalling Mongoose-OS...\e[0m'
rm -rf $INSTALL_PATH/mongoose-os
git clone --depth=1 --branch $MOS_VERSION https://github.com/cesanta/mongoose-os $INSTALL_PATH/mongoose-os

echo $'\e[36mInstalling LFS tools...\e[0m'
rm -rf $INSTALL_PATH/vfs-fs-lfs
git clone --depth=1 https://github.com/mongoose-os-libs/vfs-fs-lfs
make -C $INSTALL_PATH/vfs-fs-lfs/tools mklfs FROZEN_PATH=$INSTALL_PATH/mongoose-os/src/frozen
cp $INSTALL_PATH/vfs-fs-lfs/tools/mklfs /usr/local/bin

echo $'\e[36mIntalling SPIFFS tools...\e[0m'
rm -rf $INSTALL_PATH/vfs-fs-spiffs
git clone --depth=1 https://github.com/mongoose-os-libs/vfs-fs-spiffs
make -C $INSTALL_PATH/vfs-fs-spiffs/tools mkspiffs mkspiffs8 FROZEN_PATH=$INSTALL_PATH/mongoose-os/src/frozen SPIFFS_CONFIG_PATH=$INSTALL_PATH/vfs-fs-spiffs/include/esp32
cp $INSTALL_PATH/vfs-fs-spiffs/tools/mkspiffs $INSTALL_PATH/vfs-fs-spiffs/tools/mkspiffs8 /usr/local/bin

echo $'\e[92mDone.\e[0m'

# Create env script
echo "\
export PATH=\"\$HOME/.espressif/tools/xtensa-esp32-elf/$TOOLCHAIN_VERSION/xtensa-esp32-elf/bin:\$PATH\"
export IDF_PATH=\"$INSTALL_PATH/esp-idf\"
export MGOS_TARGET_GDB=\"\$HOME/.espressif/tools/xtensa-esp32-elf/$TOOLCHAIN_VERSION/xtensa-esp32-elf/bin/xtensa-esp32-elf-gdb\"
export MGOS_SDK_REVISION=$DOCKER_TAG
export TOOLCHAIN_VERSION=$TOOLCHAIN_VERSION
export MGOS_SDK_BUILD_IMAGE=docker.io/mgos/esp32-build:$DOCKER_TAG
export CPPFLAGS=\"\$CPPFLAGS -Wno-error\"\
" > env.sh
chmod 755 env.sh

# Create uninstall script
echo "\
echo $'\e[36mRemoving binaries from /usr/local/bin...\e[0m'
rm /usr/local/bin/mklfs
rm /usr/local/bin/mkspiffs
rm /usr/local/bin/mkspiffs8
echo $'\e[92mDone.\e[0m'\
" > uninstall.sh
chmod 755 uninstall.sh