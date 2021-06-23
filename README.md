# mos-native

Installer script to download, build and install all dependencies needed for [mos tool](https://github.com/mongoose-os/mos) to build Mongoose OS apps for ESP32 without docker.

## install
```bash
$ git clone https://github.com/v-kiniv/mos-native.git
$ cd mos-native
$ ./install.sh
```

## use
Temporary for terminal session
```bash
$ . /<fullpath-to>/mos-native/env.sh
```

Permanent, add to ~/.zshrc:
```bash
$ echo ". /<fullpath-to>/mos-native/env.sh"
```

## uninstall
```bash
$ ./uninstall.sh
```
