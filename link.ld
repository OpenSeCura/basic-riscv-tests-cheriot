OUTPUT_ARCH( "riscv" )
ENTRY(start)

SECTIONS
{
  . = 0x80000000;
  .text.init : { *(.text.init) }
  . = 0x80001000;
  .tohost : { *(.tohost) }
  . = 0x80002000;
  .text : { *(.text) }
  .test_start : { *(.test_start) }
  .data : { *(.data) }
  .bss : { *(.bss) }
  _end = .;
}
