int main()
{
    int a = 15, b = 150;
    int gcd = b, aux = a;
    int r = aux % gcd;
    while (r != 0)
    {
        aux = gcd;
        gcd = r;
        r = aux % gcd;
    }
    return 0;
}