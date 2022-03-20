import java.io.*;
import java.util.Arrays;
import java.util.Scanner;
 
public class A {
    static long huffman(long arr1[], int n) {
        long arr2[] = new long[n];
        int f1 = 0, f2 = 0;
        long result = 0;
        for (int i = 0; i < n; i++) {
            arr2[i] = (long) 100000000 * 1000 + 1;
        }
        boolean first, second, third;
        for (int i = 0; i < n - 1; i++) {
            if (f1 + 1 < n) {
                first = (((arr1[f1 + 1] + arr1[f1]) <= (arr1[f1] + arr2[f2])) && ((arr1[f1] + arr1[f1 + 1]) <= (arr2[f2] + arr2[f2 + 1])));
                second = (((arr1[f1] + arr2[f2]) <= (arr1[f1] + arr1[f1 + 1])) && ((arr1[f1] + arr2[f2]) <= (arr2[f2] + arr2[f2 + 1])));
                third = (((arr2[f2] + arr2[f2 + 1]) <= (arr1[f1] + arr1[f1 + 1])) && ((arr2[f2] + arr2[f2 + 1]) <= (arr1[f1] + arr2[f2])));
                if (first) {
                    arr2[i] = arr1[f1] + arr1[f1 + 1];
                    result = result + arr2[i];
                    f1 = f1 + 2;
                    continue;
                }
                if (second) {
                    arr2[i] = arr1[f1] + arr2[f2];
                    result = result + arr2[i];
                    f2++;
                    f1++;
                    continue;
                }
                if (third) {
                    arr2[i] = arr2[f2] + arr2[f2 + 1];
                    result = result + arr2[i];
                    f2 = f2 + 2;
                }
            } else {
                if (f1 < n) {
                    if (arr1[f1] + arr2[f2] <= arr2[f2] + arr2[f2 + 1]) {
                        arr2[i] = arr2[f2] + arr1[f1];
                        f1++;
                        f2++;
                        result = result + arr2[i];
                    } else {
                        arr2[i] = arr2[f2] + arr2[f2 + 1];
                        result = result + arr2[i];
                        f2 = f2 + 2;
                    }
                } else {
                    arr2[i] = arr2[f2] + arr2[f2 + 1];
                    result = result + arr2[i];
                    f2 = f2 + 2;
                }
            }
        }
        return result;
    }
 
    public static void main(String[] args) throws IOException {
        Scanner scanner = new Scanner(System.in);
        int n = scanner.nextInt();
        long[] a = new long[n];
        for (int i = 0; i < n; i++) {
            a[i] = scanner.nextInt();
        }
        Arrays.sort(a);
        System.out.print(huffman(a, n) + "");
    }
}