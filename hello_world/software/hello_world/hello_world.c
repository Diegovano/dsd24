#include <stdlib.h>
#include <sys/alt_stdio.h>
#include <sys/alt_alarm.h>
#include <sys/times.h>
#include <alt_types.h>
#include <system.h>
#include <stdio.h>
#include <unistd.h>

#define TEST_REPEAT 14 

// Test case 1
#define step 5
#define N 52

// Test case 2
// #define step 1/8.0
// #define N 2041

// Test case 3
// #define step 1/1024.0
// #define N 261121
// #define N 40000

// Generates the vector x and stores it in the memory
void generateVector(float x[N])
{
  int i;
  x[0] = 0;
  for (i = 1; i < N; i++) x[i] = x[i-1] + step;
}

float sumVector(float x[0], int M)
{
  float sum = 0;
  int i = 0;
  for (; i < M; i++) 
  {
    // if (i % 1000 == 0) printf("%d %d\n", (int)sum, i);
    sum += (x[i] + x[i] * x[i]);
  }
  // printf("done sum at %d\n", i);
  return sum;
}

int main(int argc, char* argv[])
{
  printf("Task 2!\n");
  printf("Ticks per second: %ld\n", alt_ticks_per_second());

  // Define input vector
  float x[N];


  // Returned result
  float y;

  generateVector(x);


  clock_t exec_t1, exec_t2;

  exec_t1 = alt_nticks();

  
  // The code that you want to time goes here
  for (int i = 0; i < (1 << TEST_REPEAT); i++) 
  y = sumVector(x, N);

  // till here
  exec_t2 = alt_nticks();

  // int i;
  // for (i = 0; i < 10; i++) y = y/2.0;

  printf("RESULT: %d\n", (int)y);
  // printf("RESULT: %d\n", (int)y >> 10);
  printf("Total ticks %d for %d iters\n", (int)(exec_t2 - exec_t1), (1 << TEST_REPEAT));


  // char buf[50];
  // gcvt((float)(exec_t2 - exec_t1) / alt_ticks_per_second() / (1 << TEST_REPEAT), 10, buf);
  // alt_putstr("Time per iter:");
  // alt_putstr(buf);
  // alt_putstr(" s \n");

  return 0;
}

