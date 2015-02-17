
export DEVELOPER_DIR := $(shell xcode-select --print-path)
SDK_iOS := $(shell xcodebuild -version -sdk iphoneos Path)

MIN_VER_iOS=-miphoneos-version-min=7.0
ARCH_IOS=-arch armv7 -arch arm64

CC_IOS=xcrun -sdk "iphoneos" clang
LD_IOS=xcrun -sdk "iphoneos" clang

all: aadbg system

aadbg: aadbg.c
	$(CC_IOS) -dynamiclib aadbg.c -o libaadbg.dylib -nostdlib $(ARCH_IOS) $(MIN_VER_IOS) -I$(SDK_iOS)/usr/include -I. -L.
	# optool install -c reexport -p "/usr/lib/system/libsystem_kernel.dylib" -t libaadbg.dylib
	# optool install -c reexport -p "/usr/lib/system/libsystem_kernel.dylib" -t libaadbg.dylib
	# optool uninstall -c load -p "/usr/lib/libSystem.B.dylib" -t libaadbg.dylib
	ldid libaadbg.dylib

system: ReSystem.c
	$(CC_IOS) -dynamiclib ReSystem.c -o libSystem.B.dylib -current_version 1.0.0 -compatibility_version 1213.0.0 -Wl,-alias,_re_ptrace,_ptrace -install_name /usr/lib/libSystem.B.dylib -laadbg -nostdlib -isysroot $(SDK_iOS) $(ARCH_IOS) $(MIN_VER_IOS) -I$(SDK_iOS)/usr/include -I. -L.

	optool install -c reexport -p "/usr/lib/system/libcache.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libcommonCrypto.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libcompiler_rt.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libcopyfile.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libcorecrypto.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libdispatch.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libdyld.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libkeymgr.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/liblaunch.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libmacho.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libremovefile.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_asl.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_blocks.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_c.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_configuration.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_coreservices.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_coretls.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_dnssd.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_info.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_kernel.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_m.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_malloc.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_network.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_networkextension.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_notify.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_platform.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_pthread.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_sandbox.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_stats.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_trace.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libunwind.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libxpc.dylib" -t libSystem.B.dylib

	optool install -c reexport -p "/usr/lib/system/libcache.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libcommonCrypto.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libcompiler_rt.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libcopyfile.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libcorecrypto.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libdispatch.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libdyld.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libkeymgr.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/liblaunch.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libmacho.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libremovefile.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_asl.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_blocks.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_c.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_configuration.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_coreservices.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_coretls.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_dnssd.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_info.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_kernel.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_m.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_malloc.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_network.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_networkextension.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_notify.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_platform.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_pthread.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_sandbox.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_stats.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libsystem_trace.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libunwind.dylib" -t libSystem.B.dylib
	optool install -c reexport -p "/usr/lib/system/libxpc.dylib" -t libSystem.B.dylib

	ldid libSystem.B.dylib
	
main: main.c
	$(CC_IOS) main.c -o main -isysroot $(SDK_iOS) $(ARCH_IOS) $(MIN_VER_IOS) -I$(SDK_iOS)/usr/include -I. -L.
	
clean:
	rm -rf libaadbg*.dylib libSystem.B.dylib

