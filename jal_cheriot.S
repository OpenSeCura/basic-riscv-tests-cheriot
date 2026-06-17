# Copyright (c) 2012-2015, The Regents of the University of California. All rights reserved.
# Copyright 2026 Google LLC
# SPDX-License-Identifier: BSD-3-Clause
# See LICENSE for license details.
#
# MODIFIED FOR CHERIOT: Replaced jal with cjal, and integer registers with capability registers.

#*****************************************************************************
# jal.S
#-----------------------------------------------------------------------------
#
# Test jal instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Test 2: Basic test
  #-------------------------------------------------------------

test_2:
  li  TESTNUM, 2
  li  ra, 0

  cjal c4, target_2
linkaddr_2:
  nop
  nop

  j fail

target_2:
  la  x2, linkaddr_2
  bne x2, x4, fail

  #-------------------------------------------------------------
  # Test delay slot instructions not executed nor bypassed
  #-------------------------------------------------------------

  TEST_CASE( 3, ra, 3, \
    li  ra, 1; \
    cjal c0, 1f; \
    addi ra, ra, 1; \
    addi ra, ra, 1; \
    addi ra, ra, 1; \
    addi ra, ra, 1; \
1:  addi ra, ra, 1; \
    addi ra, ra, 1; \
  )

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
