
/*
今天CUDA技术群里meteor兄提了个问题如下 
引用
x  x  x  x  y  y  y  y 
x  x  x  x  y  y  y  y 
x  x  x  x  y  y  y  y 
x  x  x  x  y  y  y  y 
z  z  z  z  a  a  a  a 
z  z  z  z  a  a  a  a 
z  z  z  z  a  a  a  a 
z  z  z  z  a  a  a  a 

比如这个矩阵 
我想对x那些数加一,对y那些数加二 
对z那些书加三,对a那些数加四 

介于meteor兄是新手，本着互相学习，下面是我写的一段很很简单的程序，完成上述操作，希望对meteor兄有所帮助 
*/
[quote] 

C/C++ code
#include <stdio.h>

__global__ void testkernel(int *d_A, size_t size)
{
    int dx = blockDim.x * blockIdx.x + threadIdx.x;
    int dy = blockDim.y * blockIdx.y + threadIdx.y;

    if( blockIdx.x == 0 && blockIdx.y == 0 )
       d_A[dx*size+dy] += 1;
    if( blockIdx.x == 0 && blockIdx.y == 1 )
       d_A[dx*size+dy] += 2;
    if( blockIdx.x == 1 && blockIdx.y == 0 )
       d_A[dx*size+dy] += 3;
    if( blockIdx.x == 1 && blockIdx.y == 1 )
       d_A[dx*size+dy] += 4;
}

int main( int argc, char** argv) 
{
int h_A[8][8] = {{1,1,1,1,2,2,2,2},
                 {1,1,1,1,2,2,2,2},
                 {1,1,1,1,2,2,2,2},
                 {1,1,1,1,2,2,2,2},
                 {3,3,3,3,4,4,4,4},
                 {3,3,3,3,4,4,4,4},
                 {3,3,3,3,4,4,4,4},
                 {3,3,3,3,4,4,4,4}};
 
int  *d_A, *h_B;
size_t size = 8 * 8 * sizeof(int);
size_t rsize = 8;
dim3 dimgrid(2,2);
dim3 dimblock(4,4);

h_B = (int*)malloc(size);

cudaMalloc( (void **) &d_A, size );
cudaMemcpy( d_A, h_A, size, cudaMemcpyHostToDevice );

testkernel<<<dimgrid,dimblock>>>(d_A,rsize);

cudaMemcpy( h_B, d_A, size, cudaMemcpyDeviceToHost );

for(int i = 0; i < 8; i++)
{
  for(int j = 0;j < 8; j++)
      printf("%2d ",h_B[i*rsize+j]);
printf("\n");
}

cudaFree(d_A);
free(h_B);
}



[/quote] 

介于meteor兄不理解blockDim.x和threadIdx.x，下面借上面这个例子解释，具体的请参见Programme Guide 
blockDim就是指block的维度,这里每个block是4*4的,所以blockDim.x=4 blockDim.y = 4 
threadIdx就是指block里的线程的索引号,这里每block是4*4维的,每个block里有16个thread,每个thread的threadIdx.x从0到3,threadIdx.y从0到3,和数组一样,这样解释行吗? 

以上程序测试通过。。。。