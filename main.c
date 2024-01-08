/**
 * @brief This function computes the product of two 16-bit integers by means
 * of the Booth algorithm 
 * 
 * @param m the multiplicand
 * @param q the multiplier
 * @return int the product of the multiplication
 */
int booth_multiplier(int, int);

int main()
{
    int multiplicand = -1000, multiplier = 1000;
    int result = booth_multiplier(multiplicand, multiplier);
    return 0;
}

int booth_multiplier(int m, int q)
{
    int counter = 8;
    int result = 0x0000FFFF & q;
    int booth_modifier = (0x00000003 & result) << 1;
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