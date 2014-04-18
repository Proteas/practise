export DEVELOPER_DIR := $(shell xcode-select --print-path)
PLATFORM="$(DEVELOPER_DIR)/Platforms/iPhoneOS.platform"
SDK_VER=7.1
SDK_DEVICE="$(DEVELOPER_DIR)/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS$(SDK_VER).sdk"
CC=xcrun -sdk "iphoneos" gcc

all: fsevents.h file-monitor.c
	$(CC) -o file-monitor file-monitor.c -arch armv7 -miphoneos-version-min=5.0 -isysroot $(SDK_DEVICE) -I$(SDK_DEVICE)/usr/include -I.

codesign:
	ldid -S file-monitor

clean:
	rm -f file-monitor
