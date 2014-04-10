export DEVELOPER_DIR := $(shell xcode-select --print-path)
#DEVELOPER_DIR=/Applications/Xcode-v5.0.2.app/Contents/Developer
PLATFORM="$(DEVELOPER_DIR)/Platforms/iPhoneOS.platform"
SDK_DEVICE="$(DEVELOPER_DIR)/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk"
SDK_SIMULATOR="$(DEVELOPER_DIR)/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneOS7.0.sdk"
CC=xcrun -sdk "iphoneos" gcc

all: kevent_demo.c
	$(CC) -o kevent_demo kevent_demo.c -arch armv7 -miphoneos-version-min=5.0 -isysroot $(SDK_DEVICE) -I$(SDK_DEVICE)/usr/include -I.

codesign:
	ldid -S kevent_demo

clean:
	rm main
