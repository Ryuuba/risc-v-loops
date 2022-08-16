int main()
{
    int a = 490, b = 10;
    int gcd = b, aux = a;
    for (int r = aux % gcd; r != 0; r = aux % gcd)
    {
        aux = gcd;
        gcd = r;
    }
    return 0;
}