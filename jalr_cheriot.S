# Copyright (c) 2012-2015, The Regents of the University of California. All rights reserved.
# Copyright 2026 Google LLC
# SPDX-License-Identifier: BSD-3-Clause
# See LICENSE for license details.
#
# MODIFIED FOR CHERIOT: Replaced jalr and jr with cjalr, and integer registers with capability registers.

#*****************************************************************************
# jalr.S
#-----------------------------------------------------------------------------
#
# Test jalr instruction.
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
  li  t0, 0
  la  t1, target_2

  cjalr ct0, t1, 0
linkaddr_2:
  j fail

target_2:
  la  t1, linkaddr_2
  bne x5, t1, fail

  #-------------------------------------------------------------
  # Test 3: Basic test2, rs = rd
  #-------------------------------------------------------------

test_3:
  li  TESTNUM, 3
  la  t0, target_3

  cjalr ct0, t0, 0
linkaddr_3:
  j fail

target_3:
  la  t1, linkaddr_3
  bne x5, t1, fail

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_JALR_SRC1_BYPASS( 4, 0, cjalr );
  TEST_JALR_SRC1_BYPASS( 5, 1, cjalr );
  TEST_JALR_SRC1_BYPASS( 6, 2, cjalr );

  #-------------------------------------------------------------
  # Test delay slot instructions not executed nor bypassed
  #-------------------------------------------------------------

  .option push
  .align 2
  .option norvc
  TEST_CASE( 7, t0, 4, \
    li  t0, 1; \
    la  t1, 1f; \
    cjalr c0, ct1, -4; \
    addi x5, t0, 1; \
    addi x5, t0, 1; \
    addi x5, t0, 1; \
    addi x5, t0, 1; \
1:  addi x5, t0, 1; \
    addi x5, t0, 1; \
  )
  .option pop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
