/*
 * Copyright (c) 2017 dividiti Limited.
 *
 * SPDX-License-Identifier: MIT
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
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
#ifndef __ARM_COMPUTE_LIBRARY_BENCHMARK_ALEXNET_H__
#define __ARM_COMPUTE_LIBRARY_BENCHMARK_ALEXNET_H__

// Headers under ${CK_ENV_LIB_ACL_INCLUDE}.
#include "arm_compute/core/Helpers.h"
#include "arm_compute/core/Types.h"
#include "arm_compute/runtime/NEON/functions/NEActivationLayer.h"
#include "arm_compute/runtime/NEON/functions/NEConvolutionLayer.h"
#include "arm_compute/runtime/NEON/functions/NEFullyConnectedLayer.h"
#include "arm_compute/runtime/NEON/functions/NENormalizationLayer.h"
#include "arm_compute/runtime/NEON/functions/NEPoolingLayer.h"
#include "arm_compute/runtime/NEON/functions/NESoftmaxLayer.h"
#include "arm_compute/runtime/SubTensor.h"
#include "arm_compute/runtime/Tensor.h"
#include "arm_compute/runtime/TensorAllocator.h"

// Headers under ${CK_ENV_LIB_ACL_INCLUDE_TESTS}.
#include "NEON/Helper.h"
#include "NEON/NEAccessor.h"
#include "TensorLibrary.h"
#include "model_objects/AlexNet.h"

using namespace arm_compute;
using namespace arm_compute::test;
using namespace arm_compute::test::neon;

int main(int argc, char* argv[])
{
    const unsigned int batches            = static_cast<unsigned int>(1);
    const bool         weights_transposed = true;

    model_objects::AlexNet<
        ITensor,
        Tensor,
        SubTensor,
        NEAccessor,
        NEActivationLayer,
        NEConvolutionLayer,
        NEFullyConnectedLayer,
        NENormalizationLayer,
        NEPoolingLayer,
        NESoftmaxLayer,
        DataType::F32
    >alexnet{};

    // Set up.
    alexnet.init_weights(batches, weights_transposed);
    alexnet.build();
    alexnet.allocate();

    // FIXME: references arm_compute::test::library.
    //alexnet.fill_random();

    // Run.
    alexnet.run();

    // Tear down.
    alexnet.clear();
    
    return 0;
}

#endif //__ARM_COMPUTE_LIBRARY_BENCHMARK_ALEXNET_H__
