export DEVELOPER_DIR := $(shell xcode-select --print-path)

SDK_VER_IOS=7.1
SDK_IOS_DEVICE="$(DEVELOPER_DIR)/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS$(SDK_VER_IOS).sdk"
MIN_VER_IOS=-miphoneos-version-min=5.0
ARCH_IOS=-arch armv7
CC_IOS=xcrun -sdk "iphoneos" gcc

SDK_VER_OSX=10.8
SDK_OSX="$(DEVELOPER_DIR)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX$(SDK_VER_OSX).sdk"
MIN_VER_OSX=-mmacosx-version-min=10.8
ARCH_OSX=-arch x86_64
CC_OSX=xcrun -sdk "macosx" gcc

all: iOS OSX
	lipo -create file-monitor-armv7 file-monitor-x86_64 -output file-monitor
	rm -f file-monitor-armv7 file-monitor-x86_64

iOS: fsevents.h file-monitor.c
	$(CC_IOS) -o file-monitor-armv7 file-monitor.c $(ARCH_IOS) $(MIN_VER_IOS) -isysroot $(SDK_IOS_DEVICE) -I$(SDK_IOS_DEVICE)/usr/include -I.
	ldid -S file-monitor-armv7

OSX: fsevents.h file-monitor.c
	$(CC_OSX) -o file-monitor-x86_64 file-monitor.c $(ARCH_OSX) $(MIN_VER_OSX) -isysroot $(SDK_OSX) -I$(SDK_OSX)/usr/include -I.

clean:
	rm -f file-monitor
