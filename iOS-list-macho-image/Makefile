export DEVELOPER_DIR := $(shell xcode-select --print-path)
SDK_VER_IOS = 7.1
SDK_IOS_DEVICE = "$(DEVELOPER_DIR)/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS$(SDK_VER_IOS).sdk"
MIN_VER_IOS = -miphoneos-version-min=5.0
ARCH_IOS = -arch armv7
CC_IOS = xcrun -sdk "iphoneos" gcc

SDK_VER_OSX = 10.8
SDK_OSX = "$(DEVELOPER_DIR)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX$(SDK_VER_OSX).sdk"
MIN_VER_OSX = -mmacosx-version-min=10.8
ARCH_OSX = -arch x86_64
CC_OSX = xcrun -sdk "macosx" gcc

all: app-ios codesign

app-ios: list-macho-image.c
	$(CC_IOS) -o list-macho-image list-macho-image.c $(ARCH_IOS) $(MIN_VER_IOS) -isysroot $(SDK_IOS_DEVICE) -I$(SDK_IOS_DEVICE)/usr/include -I.

codesign:
	ldid -S list-macho-image

clean:
	rm -f list-macho-image
