/*
 * Copyright 2026 Google LLC
 * SPDX-License-Identifier: BSD-3-Clause
 * See LICENSE for license details.
 */

#pragma once

#define TESTNUM x3
#define RVTEST_RV32U
#define RVTEST_RV64U

.macro la reg, symbol
.L1\@:
  auipcc \reg, %pcrel_hi(\symbol)
  cincoffset \reg, \reg, %pcrel_lo(.L1\@)
.endm

.macro la_abs reg, symbol
  lui \reg, %hi(\symbol)
  addi \reg, \reg, %lo(\symbol)
.endm

.macro init_regs symbol
  la_abs x2, \symbol
  cspecialr c1, mtcc
  csetaddr c1, c1, x2
  cspecialw mtcc, c1

  li x1, 0
  li x2, 0
  li x3, 0
  li x4, 0
  li x5, 0
  li x6, 0
  li x7, 0
  li x8, 0
  li x9, 0
  li x10, 0
  li x11, 0
  li x12, 0
  li x13, 0
  li x14, 0
  li x15, 0
.endm

#define RVTEST_CODE_BEGIN \
.section .tohost, "aw", @progbits; \
.global tohost; \
.p2align 3; \
tohost: .dword 0; \
.size tohost, 8; \
\
.section .data, "aw", @progbits; \
.size data, 0x1000; \
\
.section .test_start, "ax", @progbits; \
.global start; \
.p2align 2; \
.type start,@function; \
start: \
  init_regs trap_vector

#define RVTEST_PASS \
  li gp, 1; \
  j write_tohost

#define RVTEST_FAIL \
  j write_tohost

#define RVTEST_CODE_END \
write_tohost: \
  la_abs a3, tohost; \
  cspecialr ca4, mtdc; \
  csetaddr ca4, ca4, a3; \
  csw gp, 0(ca4); \
1: cj 1b; \
.p2align 3; \
trap_vector: \
  li gp, 1337; \
  j write_tohost

#define RVTEST_DATA_BEGIN .align 4;
#define RVTEST_DATA_END
