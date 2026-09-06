/*
 * Copyright 2026 Google LLC
 * SPDX-License-Identifier: BSD-3-Clause
 * See LICENSE for license details.
 */

OUTPUT_ARCH( "riscv" )
ENTRY(start)


SECTIONS
{
  . = 0x80000000;
  .text : {
    *(.text.init)
    *(.text.test_start)
    *(.text)
  }
  . = ALIGN(8);
  .data : {
    _data_start = .;
    *(.data)
  }
  . = ALIGN(8);
  .tohost : { *(.tohost) }
  . = ALIGN(8);
  .bss : { *(.bss) }
  _end = .;
}
