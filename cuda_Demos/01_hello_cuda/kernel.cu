#include <stdio.h>

//global : host ???ã? device ִ??
__global__ void hello_from_gpu()
{
	printf("Hello World from the GPU!\n");
}

int main(void)
{
	hello_from_gpu << <2, 2 >> > ();
	cudaDeviceSynchronize();
	return 0;

}