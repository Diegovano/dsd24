#include <system.h>
#include <stdio.h>
#include <math.h>

#define ALT_CI_CORDIC_0(A) __builtin_custom_fnf(ALT_CI_CORDIC_0_N,(A))
#define ALT_CI_CORDIC_0_N 0x0


int main()
{
  float in = -0.5;
  float out = ALT_CI_CORDIC_0(in);
  printf("gd cos(%f) = %f\n", in, cos(in));
  printf("my cos(%f) = %f\n", in, out);

  return 0;
}

// -.59 1 01111110 00101111110111110011110
//  .73 0 01111110 01110110100111111111000
