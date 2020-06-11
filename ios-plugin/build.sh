#!/bin/sh

scons platform=ios || exit 1
scons platform=ios ios_arch=x86_64 || exit 1

lipo -create -output bin/libamplitude.fat.a bin/libamplitude_arm64.a bin/libamplitude_x86_64.a

rm bin/libamplitude_arm64.a
rm bin/libamplitude_x86_64.a
