#include <stdio.h>
#include <stdlib.h>

#define MAX_NUMBERS 100  // 假設最多有 100 個數字
#define MAX_LINE 1024    // 假設每行的最大長度

// 將數字轉成二進制字串
void decimal_to_binary(int number, char *binary, int size) {
    binary[size - 1] = '\0';
    for (int i = size - 2; i >= 0; i--) {
        binary[i] = (number % 2) ? '1' : '0';
        number /= 2;
    }
}

int main() {
    char input_file[] = "../data/data.txt";        // 輸入文本檔
    char binary_file[] = "../data/output_binary.txt"; // 輸出二進制檔
    char hex_file[] = "../data/output_hex.txt";       // 輸出十六進制檔

    FILE *fin = fopen(input_file, "r");
    FILE *fbinary = fopen(binary_file, "w");
    FILE *fhex = fopen(hex_file, "w");

    if (!fin || !fbinary || !fhex) {
        perror("Error opening file");
        return EXIT_FAILURE;
    }

    int numbers[MAX_NUMBERS];
    int count = 0;

    // 讀取輸入檔案
    while (fscanf(fin, "%d", &numbers[count]) != EOF && count < MAX_NUMBERS) {
        count++;
    }

    // 處理每個數字
    for (int i = 0; i < count; i++) {
        char binary[33]; // 假設 32 位整數的二進制表示
        decimal_to_binary(numbers[i], binary, 33);

        // 寫入二進制文件
        fprintf(fbinary, "%s\n", binary);

        // 寫入十六進制文件
        fprintf(fhex, "%X\n", numbers[i]);
    }

    // 關閉檔案
    fclose(fin);
    fclose(fbinary);
    fclose(fhex);

    printf("Conversion complete. Check '%s' and '%s'.\n", binary_file, hex_file);
    return 0;
}
