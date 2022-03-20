import java.util.Scanner;

public class E {

    public static void main(String[] args) {
        Scanner sc1 = new Scanner(System.in);
        int n = sc1.nextInt();
        int count = (int) Math.pow(2, n);
        String[] chart = new String[count];
        int[][] res0 = new int[count][count];


        for (int i = 0; i < count; i++) {
            chart[i] = sc1.next();
            res0[0][i] = sc1.nextInt();
        }


        int[] res1 = new int[count];
        int res = res0[0][0];
        res1[0] = res;
        for (int i = 0; i < res0.length - 1; i++) {
            for (int j = 1; j < res0[i].length; j++) {
                res = (res + res0[i][j]) % 2;
                res0[i + 1][j - 1] = res;
                res = res0[i][j];
            }
            res1[i + 1] = res0[i + 1][0];
            res = res0[i + 1][0];
        }

        for (int i = 0; i < count; i++) {
            System.out.println(chart[i] + " " + res1[i]);
        }
    }
}
