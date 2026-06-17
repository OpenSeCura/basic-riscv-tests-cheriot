# Copyright (c) 2012-2015, The Regents of the University of California. All rights reserved.
# Copyright 2026 Google LLC
# SPDX-License-Identifier: BSD-3-Clause
#
# MODIFIED FOR CHERIOT: Replaced integer memory load/stores with capability ops (clh, csh) and jalr with cjalr to perform capability-safe self-modifying code tests.
# See LICENSE for license details.

#*****************************************************************************
# fence_i.S
#-----------------------------------------------------------------------------
#
# Test self-modifying code and the fence.i instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

li a3, 111
la ca2, insn
clh a0, 0(ca2)
clh a1, 2(ca2)

# test I$ hit
.align 6
la ct0, 2f
csh a0, 0(ct0)
csh a1, 2(ct0)
fence.i

la ca5, 2f
cjalr ct1, ca5, 0
TEST_CASE( 2, a3, 444, nop )

# test prefetcher hit
li a4, 100
1: addi a4, a4, -1
bnez a4, 1b

la ct0, 3f
csh a0, 0(ct0)
csh a1, 2(ct0)
fence.i

.align 6
la ca5, 3f
cjalr ct1, ca5, 0
TEST_CASE( 3, a3, 777, nop )

TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

insn:
  addi a3, a3, 333

2: addi a3, a3, 222
cjalr ca5, ct1, 0

3: addi a3, a3, 555
cjalr ca5, ct1, 0

RVTEST_DATA_END
