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

all: dylib app codesign pkg

dylib: interposing-lib.c
	$(CC_IOS) -dynamiclib -o interposing-lib.dylib interposing-lib.c $(ARCH_IOS) $(MIN_VER_IOS) -isysroot $(SDK_IOS_DEVICE) -I$(SDK_IOS_DEVICE)/usr/include -I.

app: interposing-main.c
	$(CC_IOS) -o interposing-main interposing-main.c $(ARCH_IOS) $(MIN_VER_IOS) -isysroot $(SDK_IOS_DEVICE) -I$(SDK_IOS_DEVICE)/usr/include -I.

codesign:
	ldid -S interposing-lib.dylib
	ldid -S interposing-main

pkg:
	tar czvf interposing.tgz interposing-main interposing-lib.dylib run-interposing-test.sh

clean:
	rm -f interposing-lib.dylib
	rm -f interposing-main
	rm -f interposing.tgz
