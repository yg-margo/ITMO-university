import java.util.Arrays;
import java.util.Scanner;

public class B {

    public static byte one1(String chart) {
        if (chart.charAt(chart.length() - 1) == '1') {
            return 1;
        } else {
            return 0;
        }
    }

    public static byte null0(String chart) {
        if (chart.charAt(0) == '0') {
            return 1;
        } else {
            return 0;
        }
    }

    public static byte sd(String chart) {
        if (chart.length() == 1) {
            return 0;
        }
        for (int i = 0; i < (chart.length()/2); i++) {
            if (chart.charAt(i) == chart.charAt(chart.length() - i - 1)) {
                return 0;
            }
        }
        return 1;
    }

    public static int[] byteVector(int num, int len) {
        int[] l = new int[len];
        for (int i = 0; i < len; i++) {
            l[len - i - 1] = num % 2;
            num = num / 2;
        }
        return l;
    }

    public static byte mon(int cnt, String chart) {
        for (int i = 0; i < chart.length(); i++) {
            int[] vec =  byteVector(i, cnt);
            int[] dominVec = getDominPos(vec);
            if (dominVec[0] != 0) {
                for (int j = 0; j < dominVec.length - 1; j++) {
                    if (chart.charAt(i) > chart.charAt(dominVec[j])) {
                        return 0;
                    }
                }
            }
        }
        return 1;
    }

    public static int[] getDominPos(int[] vec) {
        int[] l = new int[1];
        for (int i = 0; i < vec.length; i++) {
            if (vec[i] == 0) {
                vec[i] = 1;
                l[l.length - 1] = intVec(vec);
                vec[i] = 0;
                l = Arrays.copyOf(l, l.length + 1);
            }
        }
        return l;
    }

    public static int intVec(int[] vec) {
        int num = 0;
        for (int i = vec.length - 1; i >= 0; i--) {
            num += Math.pow(2, vec.length - i - 1) * vec[i];
        }
        return num;
    }

    public static byte isLineFunc(int cnt, String chart) {
        int len = (int) Math.pow(2, cnt);
        int[][] matrix = new int[len][len];

        for (int i = 0;  i < len; i++) {
            matrix[0][i] = Integer.parseInt(Character.toString(chart.charAt(i)));
        }

        for (int i = 1; i < len; i++) {
            for (int j = 0; j < len; j++) {
                if (j == len - 1) {
                    break;
                } else {
                    matrix[i][j] = (matrix[i - 1][j] + matrix[i - 1][j + 1]) % 2;
                }
            }
        }

        int[] res = new int[len];
        for (int i = 0; i < len; i++) {
            res[i] = matrix[i][0];
        }

        int k = 0;
        for (int i = 1; i < len; i++) {
            if (i == Math.pow(2, k)) {
                k++;
            }
            else {
                if (res[i] == 1)  {
                    return 0;
                }
            }
        }
        return 1;
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int sc1 = scanner.nextInt();
        int[][] r = new int[sc1][5];
        boolean isTrue = false;

        for (int i = 0; i < sc1; i++) {
            int sc = scanner.nextInt();
            String chart = scanner.next();
            r[i][0] = null0(chart);
            r[i][1] = one1(chart);
            r[i][2] = sd(chart);
            r[i][3] = mon(sc, chart);
            r[i][4] = isLineFunc(sc, chart);
        }

        for (int i = 0; i < sc1; i++) {
            for (int j = 0; j < 5; j++) {
                System.err.print(r[i][j] + " ");
            }
            System.err.println("");
        }

        for (int i = 0; i < 5; i++) {
            int cnt2 = 0;
            for (int j = 0; j < sc1; j++) {
                cnt2 += r[j][i];
            }
            if (cnt2 < sc1) {
                isTrue = true;
            } else {
                isTrue = false;
                break;
            }
        }

        if (isTrue) {
            System.out.print("YES");
        } else {
            System.out.print("NO");
        }

    }
}

