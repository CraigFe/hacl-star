/* MIT License
 *
 * Copyright (c) 2016-2020 INRIA, CMU and Microsoft Corporation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "libintvector.h"
#include "kremlin/internal/types.h"
#include "kremlin/lowstar_endianness.h"
#include <string.h>
#include "kremlin/internal/target.h"

#ifndef __Vale_Inline_H
#define __Vale_Inline_H




inline static void cswap2_inline(u64 bit, u64 *p0, u64 *p1);

inline static void fsqr_inline(u64 *tmp, u64 *f1, u64 *out1);

inline static void fsqr2_inline(u64 *tmp, u64 *f1, u64 *out1);

inline static void fmul_inline(u64 *tmp, u64 *f1, u64 *out1, u64 *f2);

inline static void fmul2_inline(u64 *tmp, u64 *f1, u64 *out1, u64 *f2);

inline static void fmul1_inline(u64 *out1, u64 *f1, u64 f2);

inline static u64 add1_inline(u64 *out1, u64 *f1, u64 f2);

inline static void fadd_inline(u64 *out1, u64 *f1, u64 *f2);

inline static void fsub_inline(u64 *out1, u64 *f1, u64 *f2);

#define __Vale_Inline_H_DEFINED
#endif