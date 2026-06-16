LLVM_DIR := ~/work/Cheriot/llvm-project/builds/cheriot-llvm
CXX := $(LLVM_DIR)/bin/clang
CXXOBJDUMP := $(LLVM_DIR)/bin/llvm-objdump

CXXCFLAGS := -mabi=cheriot-baremetal -T link.ld -target riscv32-unknown-unknown -mcpu=cheriot -mrelax -fshort-wchar -nostdinc -Oz -g -ffunction-sections -fdata-sections -fomit-frame-pointer -fno-builtin -fno-exceptions -fno-asynchronous-unwind-tables -fno-c++-static-destructors -fno-rtti -Werror -nostdlib -fvisibility=hidden -DNDEBUG -Qunused-arguments

CXXOBJDUMPFLAGS := -glxsdrS --demangle

SRCS := $(wildcard *.S)
BINS := $(patsubst %.S,binaries/%.elf,$(SRCS))
DUMPS := $(patsubst %.S,binaries/%.dump,$(SRCS))

.PHONY: all clean

all: $(BINS) $(DUMPS)

binaries:
	mkdir -p binaries

binaries/%.elf: %.S | binaries
	$(CXX) $(CXXCFLAGS) $< -o $@

binaries/%.dump: binaries/%.elf
	$(CXXOBJDUMP) $(CXXOBJDUMPFLAGS) $< > $@

clean:
	rm -rf binaries
