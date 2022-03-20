import java.io.*;
import java.util.Scanner;

public class D {

    public static void main(String[] args) throws IOException {
        Scanner scanner = new Scanner(System.in);
        String s = scanner.nextLine();
        int n = s.length();
        int mvt[] = new int[26];
        for (int i = 0; i < 26; i++) {
            mvt[i] = i + 1;
        }
        for (int i = 0; i < n; i++) {
            int l = (int) s.charAt(i) - 97;
            int cnt = mvt[l];
            System.out.print(cnt + " ");
            for (int j = 0; j < 26; j++) {
                if (mvt[j] < cnt) {
                    mvt[j]++;
                }
            }
            mvt[l] = 1;
        }
    }
}