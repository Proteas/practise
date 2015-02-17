
export SDK_IOS_DEV := $(shell xcodebuild -version -sdk iphoneos Path)

MIN_VER_IOS=-miphoneos-version-min=7.0
ARCH_IOS=-arch armv7 -arch arm64
CC_IOS=xcrun -sdk "iphoneos" clang

all:
	$(CC_IOS) -dynamiclib -o libaadbg.dylib aadbg.c $(ARCH_IOS) $(MIN_VER_IOS) -isysroot $(SDK_IOS_DEV)
	ldid libaadbg.dylib

test: test.c
	$(CC_IOS) -o test test.c -laadbg $(ARCH_IOS) $(MIN_VER_IOS) -isysroot $(SDK_IOS_DEV) -L.
	ldid test

clean:
	rm -rf libaadbg.dylib test
