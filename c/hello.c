#include <stdio.h>

int main() {
    int x = 10;
    int y = 5;

    int sum = x + y;
    int difference = x - y;
    int product = x * y;
    float quotient = (float)x / y;
    int remainder = x % y;

    printf("Sum: %d\n", sum);
    printf("Difference: %d\n", difference);
    printf("Product: %d\n", product);
    printf("Quotient: %.2f\n", quotient);
    printf("Remainder: %d\n", remainder);

    return 0;
}
