#pragma once

#include "tensor.hpp"

__device__ void stress_calculation(const tensor<double, 3, 3> & du_dx, double C1, double D1, tensor< double, 3, 3 >& sigma);

namespace cuda_kernels {
    void mock_fem_loop();
};