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

#define INIT_BUFSIZE 4096

__global__ void strrev(char *str) {
	int size = 0;
        while (str[size] != '\0') {
                size++;
        }
	for(int i=0;i<size/2;++i) {
		char t = str[i];
		str[i] = str[size-1-i];
		str[size-1-i] = t;
	}
}

int main(int argc, char *argv[])
{
	int fd;
	char *system_buf;
	char *gpumem_buf;
	int buf_size = INIT_BUFSIZE;
	system_buf = (char*)malloc(buf_size);
	cudaMalloc((void**)&gpumem_buf, buf_size);

	fd = open(argv[1], O_RDWR);
	pread(fd, system_buf, buf_size, 0);
	cudaMemcpy(gpumem_buf, system_buf, buf_size, cudaMemcpyHostToDevice);
	strrev<<<1,1>>>(gpumem_buf);

	cudaMemcpy(system_buf, gpumem_buf, buf_size, cudaMemcpyDeviceToHost);
	printf("%s: %s\n", argv[1], system_buf);

	cudaFree(gpumem_buf);
	free(system_buf);

	close(fd);
}
