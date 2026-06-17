# Copyright (c) 2012-2015, The Regents of the University of California. All rights reserved.
# Copyright 2026 Google LLC
# SPDX-License-Identifier: BSD-3-Clause
#
# MODIFIED FOR CHERIOT: 
# - The integer `auipc` and its `lla` pseudo-instruction are removed from the CHERIoT ISA.
# - Rewrote the test to use `auipcc` + `cincoffset` to explicitly generate capabilities.
# - Replaced integer `jal` with capability `cjal` to capture the PC capability.
# - Added `cgetaddr` to extract the integer addresses from both capabilities so their delta can be verified.
# See LICENSE for license details.

#*****************************************************************************
# auipc.S
#-----------------------------------------------------------------------------
#
# Test auipc instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  TEST_CASE(2, a0, 10000, \
    .align 3; \
    auipcc ca0, 2; \
    cincoffset ca0, ca0, 0x710; \
    cjal ca1, 1f; \
    1: cgetaddr a0, ca0; \
    cgetaddr a1, ca1; \
    sub a0, a0, a1; \
  )

  TEST_CASE(3, a0, -10000, \
    .align 3; \
    auipcc ca0, 0xffffe; \
    cincoffset ca0, ca0, -0x710; \
    cjal ca1, 1f; \
    1: cgetaddr a0, ca0; \
    cgetaddr a1, ca1; \
    sub a0, a0, a1; \
  )

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
