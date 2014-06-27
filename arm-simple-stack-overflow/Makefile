export DEVELOPER_DIR := $(shell xcode-select --print-path)

SDK_VER_IOS=7.1
SDK_IOS_DEVICE="$(DEVELOPER_DIR)/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS$(SDK_VER_IOS).sdk"
MIN_VER_IOS=-miphoneos-version-min=5.0
ARCH_IOS=-arch armv7
CC_IOS=xcrun -sdk "iphoneos" gcc

TARGET=exploit

all: exploit.c
	$(CC_IOS) -o $(TARGET) $(TARGET).c $(ARCH_IOS) $(MIN_VER_IOS) -fno-pie -fno-stack-protector -isysroot $(SDK_IOS_DEVICE) -I$(SDK_IOS_DEVICE)/usr/include -I.
	ldid -S $(TARGET)

clean:
	rm -f $(TARGET)
