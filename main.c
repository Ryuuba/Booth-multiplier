#include <stdint.h>

/**
 * @brief This function computes the product of two 16-bit integers by means
 * of the Booth algorithm 
 * 
 * @param m the multiplicand
 * @param q the multiplier
 * @return int32_t the product of the multiplication
 */
int32_t booth_multiplier(int16_t, int16_t);

int main()
{
    int16_t multiplicand = -1000, multiplier = 1000;
    int32_t result = booth_multiplier(multiplicand, multiplier);
    return 0;
}

int32_t booth_multiplier(int16_t m, int16_t q)
{
    int8_t counter = 8;
    int32_t result = 0x0000FFFF & q;
    int32_t booth_modifier = (0x00000003 & result) << 1;
    while (counter > 0)
    {
        result = result >> 1;
        if (booth_modifier == 1 || booth_modifier == 2)
            result += m << 15;
        else if (booth_modifier == 3)
            result += m << 16;
        else if (booth_modifier == 4)
            result -= m << 16;
        else if (booth_modifier == 5 || booth_modifier == 6)
            result -= m << 15;
        booth_modifier = 0x00000007 & result;
        result = result >> 1;
        counter--;
    }
    return result;
}