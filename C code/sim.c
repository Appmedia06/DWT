#include <stdio.h>
#include <stdlib.h>

#define MAX_LEN 31
enum DWT_TYPE {LOW, HIGH};




int high_pass(int *input, int idx, int len)
{
    if (idx > len - 3)
        return 0;

    return (input[idx + 1] - (input[idx] >> 1)) - (input[idx + 2] >> 1);
}

int low_pass(int *input, int idx, int len)
{
    if (idx > len - 5)
        return 0;

    return input[idx + 2] + ((high_pass(input, idx, len)) >> 2) + ((high_pass(input, idx + 2, len)) >> 2);
}

int get_setNum(int DWT_TYPE, int len)
{
    if (DWT_TYPE == LOW) {
        return ((len - 5) >> 1) + 1;
    }
    else if (DWT_TYPE == HIGH) {
        return ((len - 3) >> 1) + 1;
    }
    else 
        return 0;
}

int *DWT_1D1L(int *input, int len)
{
    int low_setNum = get_setNum(LOW, len), high_setNum = get_setNum(HIGH, len);

    int *lowSig = (int *) malloc(low_setNum * sizeof(int));
    int *highSig = (int *) malloc(high_setNum * sizeof(int));

    for (int i = 0, j = 0, k = 0; i <= len - 3; i += 2, j++, k++) {
        
        if (i <= len - 5) {
            lowSig[j] = low_pass(input, i, len);
        }
        if  (i <= len - 3) {
            highSig[k] = high_pass(input, i, len);
        }
    }

    for (int i = 0; i < low_setNum; i++) {
        printf("low[%d] = %d, ", i, lowSig[i]);
    }
    printf("\n");
    for (int i = 0; i < high_setNum; i++) {
        printf("high[%d] = %d, ", i, highSig[i]);
    }
    printf("\n");

    free(highSig);
    return lowSig;
}

int main(void)
{
    int input1[MAX_LEN] = {30, 60, 30, 80, 40, 70, 28, 66, 44, 77, 35, 52, 32, 72, 20, 38, 29, 62, 41, 
    85, 39, 56, 41, 68, 29, 57, 39, 52, 25, 68, 37};
    
    
    // int input1[MAX_LEN] = {0};

    // for (int i = 0; i < 32; i++) {
    //     input1[i] = i; 
    // }

    int *low1 = DWT_1D1L(input1, MAX_LEN);
    printf("--------------------------------------\n");
    int *low2 = DWT_1D1L(low1, get_setNum(LOW, MAX_LEN));
    return 0;
}