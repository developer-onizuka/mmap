#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include <cuda.h>
#include <cuda_runtime.h>

__global__ void cuda_hello(){
    printf("Hello World from GPU!\n");
}
int main() {
    cuda_hello<<<1,1>>>(); 
    cudaDeviceSynchronize();
    return 0;
}
