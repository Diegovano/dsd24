#include <system.h>
#include <stdio.h>
#include <math.h>

#define ALT_CI_CORDIC_0(A) __builtin_custom_fnf(ALT_CI_CORDIC_0_N,(A))
#define ALT_CI_CORDIC_0_N 0x0


int main()
{
  float in = 244;
  float out = ALT_CI_CORDIC_0(in);
  printf("true y(%f) = %f\n", in, 0.5 * in + in * in  * cos((in-128)/128));
  printf("my y(%f) = %f\n", in, out);

  return 0;
}

// -.59 1 01111110 00101111110111110011110
//  .73 0 01111110 01110110100111111111000
