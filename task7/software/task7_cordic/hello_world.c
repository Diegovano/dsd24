#include <system.h>
#include <stdio.h>
#include <math.h>
#include <sys/alt_alarm.h>
#include <sys/times.h>

#define ALT_CI_CORDIC_0(A) __builtin_custom_fnf(ALT_CI_CORDIC_0_N,(A))
#define ALT_CI_CORDIC_0_N 0x0


// Test case 1
// #define step 5
// #define N 52
// #define NUM_CASES 1000

// Test case 2
// #define step 1/8.0
// #define N 2041
// #define NUM_CASES 100


// Test case 3
#define step 1/1024.0
#define N 261121
#define NUM_CASES 1


// Test case 4
// #define N 2323
// #define RANDSEED 334
// #define MAXVAL 255
// #define NUM_CASES 10


// int main()
// {
//   float in = 244;
//   float out = ALT_CI_CORDIC_0(in);
//   printf("true y(%f) = %f\n", in, 0.5 * in + in * in  * cos((in-128)/128));
//   printf("my y(%f) = %f\n", in, out);

//   return 0;
// }

#ifdef RANDSEED

void generateVector(float x[N])
{
  int i;
  srand(RANDSEED);
  for (i = 0; i < N; i++)
  {
    x[i] = ((float) rand() / (float) RAND_MAX) * MAXVAL;
  }
}

#else

// Generates the vector x and stores it in the memory
void generateVector(float x[N])
{
  int i;
  x[0] = 0;
  for (i = 1; i < N; i++) x[i] = x[i-1] + step;
}

#endif

float theFunction(float x[0], int M) {
  float sum = 0;
  int i = 0;
  for (; i < M; i++) 
  {
    sum += ALT_CI_CORDIC_0(x[i]);
  }
  return sum;
}

int main(int argc, char* argv[])
{
  const int numIterations = NUM_CASES;
  printf("Task 7!\n");
  // printf("Ticks per second: %ld\n", alt_ticks_per_second());
  printf("Running %d tests\n", numIterations);

  // Define input vector
  float x[N];


  // Returned result
  volatile float y;

  generateVector(x);


  volatile clock_t exec_t1, exec_t2;

  // const int numIterations = 1 << TEST_REPEAT;

  exec_t1 = times(NULL);

  int y1 = 0;

  for (int i = 0; i < numIterations; i++) {
    y = theFunction(x, N);
  }
  
  // till here
  exec_t2 = times(NULL);

  volatile int elapsedTicks = (int)(exec_t2 - exec_t1);
  printf("ElpasedTicks: %d\n", elapsedTicks);
  printf("RESULT: %f, %x\n", y, *(int*)(&y));
  printf("Num Iterations: %d\n", y1);
  // printf("Total ticks %d for %d iters\n", elapsedTicks , numIterations);
  // printf("Time Taken: %f\n",(float) elapsedTicks/numIterations);


  return 0;
}