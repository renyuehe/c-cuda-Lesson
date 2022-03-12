#include <stdio.h>

//global : host µ÷ÓÃ£¬ device Ö´ÐÐ
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