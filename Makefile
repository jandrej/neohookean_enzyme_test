CXX = /usr/workspace/andrej1/local/llvm-13.0.0/bin/clang++
CXX_FLAGS = -g -O3 -ffast-math -std=c++17
ENZYME_DIR = /usr/workspace/andrej1/repos/Enzyme/enzyme/build/Enzyme
ENZYME_CXX_FLAGS = -fno-experimental-new-pass-manager -Xclang -load -Xclang $(ENZYME_DIR)/ClangEnzyme-13.so
GOOGLE_BENCHMARK_DIR = ./benchmark-1.6.0
CUDA_DIR = /usr/tce/packages/cuda/cuda-11.4.1
INCLUDE_FLAGS = -I$(GOOGLE_BENCHMARK_DIR)/include -I$(CUDA_DIR)/include
LINK_FLAGS = -L$(GOOGLE_BENCHMARK_DIR)/build/src -lbenchmark -lpthread -L/usr/tce/packages/cuda/cuda-11.4.1/lib64 -lcudart -lrt -Wl,-rpath,/usr/tce/packages/cuda/cuda-11.4.1/lib64 -Wl,--build-id -L$(CUDA_DIR)/lib64 -lcuda

KERNEL_OBJECTS = kernel_launch_test.o

all: benchmark

benchmark: main.o $(KERNEL_OBJECTS)
	$(CXX) $(CXX_FLAGS) -o benchmark main.o $(KERNEL_OBJECTS) $(LINK_FLAGS)

%.o: %.cpp
	$(CXX) $(CXX_FLAGS) $(ENZYME_CXX_FLAGS) -c -o $@ $< $(INCLUDE_FLAGS)

%.o: %.cu
	$(CXX) $(CXX_FLAGS) $(ENZYME_CXX_FLAGS) --cuda-gpu-arch=sm_70 -c -o $@ $< 
    
clean:
	rm *.o
