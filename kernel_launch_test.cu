#include "cuda_kernels.hpp"

template<typename return_type, typename... Args>
__device__ return_type __enzyme_fwddiff(Args...);

__device__ int enzyme_dup;
__device__ int enzyme_dupnoneed;
__device__ int enzyme_out;
__device__ int enzyme_const;

namespace cuda_kernels {

template <int dim, int num_el, int num_qp> 
__global__ void mock_fem_loop_kernel(
  tensor<double, dim, dim> &du_dx,
  tensor<double, dim, dim> &perturbation,
  double &C1,
  double &D1,
  tensor<double, dim, dim> &sigma,
  tensor<double, dim, dim> &dsigma) {
  
  for (int e = 0; e < num_el; e++) {
    for (int q = 0; q < num_qp; q++) {
      __enzyme_fwddiff<void>(stress_calculation,
                        enzyme_dup, &du_dx, &perturbation,
                        enzyme_const, C1,
                        enzyme_const, D1,
                        enzyme_dupnoneed, &sigma, &dsigma);
    }
  }
}

void mock_fem_loop() {
  double epsilon = 1.0e-8;
  tensor<double, 3, 3> du_dx = {{{0.2, 0.4, -0.1}, {0.2, 0.1, 0.3}, {0.01, -0.2, 0.3}}};
  tensor<double, 3, 3> perturbation = {{{1.0, 0.2, 0.8}, {2.0, 0.1, 0.3}, {0.4, 0.2, 0.7}}};

  double C1 = 100.0;
  double D1 = 50.0;


  tensor<double, 3, 3> sigma{};
  tensor<double, 3, 3> dsigma{};

  mock_fem_loop_kernel<3, 1024, 9><<<1,1>>>(du_dx, perturbation, C1, D1, sigma, dsigma);
}

};