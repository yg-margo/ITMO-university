import java.util.Scanner;

public class A {
    public static void compare(int[][] array) {
        int res = 0;
        int[][] arr = new int[array.length][array.length];

        for (int i = 0; i < array.length; i++) {
            for (int j = 0; j < array[0].length; j++) {
                if (i == j) {
                    if (array[i][j] == 1) {
                        res += 1;
                    } else {
                        res = 0;
                    }
                }
            }
        }
        if (res == array.length) {
            res = 1;
        } else {
            res = 0;
        }
        System.out.print(res + " ");

        for (int i = 0; i < array.length; i++) {
            for (int j = 0; j < array[0].length; j++) {
                if (i == j) {
                    if (array[i][j] == 0) {
                        res += 1;
                    } else {
                        res = 0;
                    }
                }
            }
        }
        if (res == array.length) {
            res = 1;
        } else {
            res = 0;
        }
        System.out.print(res + " ");

        res = 0;
        int l = array.length * (array.length - 1);
        for (int i = 0; i < array.length; i++) {
            for (int j = 0; j < array[0].length; j++) {
                if (i != j) {
                    if (array[i][j] == array[j][i]) {
                        res += 1;
                    } else {
                        res = 0;
                    }
                }
            }
        }
        if (res == l) {
            res = 1;
        } else {
            res = 0;
        }
        System.out.print(res + " ");

        int[][] unitMatrix = new int[array.length][array.length];
        for (int i = 0; i < array.length; i++) {
            for (int j = 0; j < array.length; j++) {
                if (i == j) {
                    unitMatrix[i][j] = 1;
                } else {
                    unitMatrix[i][j] = 0;
                }
            }
        }
        int[][] multiMatrix = new int[array.length][array.length];
        for (int i = 0; i < array.length; i++) {
            for (int j = 0; j < array.length; j++) {
                multiMatrix[i][j] = array[i][j] * array[j][i];
            }
        }
        for (int i = 0; i < array.length; i++) {
            for (int j = 0; j < array.length; j++) {
                if (multiMatrix[i][j] <= unitMatrix[i][j]) {
                    res += 1;
                } else {
                    res = 0;
                }
            }
        }
        if (res == array.length * array.length) {
            res = 1;
        } else {
            res = 0;
        }
        System.out.print(res + " ");

        for (int i = 0; i < array.length; i++) {
            for (int k = 0; k < array.length; k++) {
                for (int j = 0; j < array.length; j++) {
                    arr[i][k] += array[i][j] * array[j][k];
                }
            }
        }
        res = 0;
        for (int i = 0; i < array.length; i++) {
            for (int j = 0; j < array.length; j++) {
                if (arr[i][j] > 1) {
                    arr[i][j] = 1;
                }
                if (arr[i][j] <= array[i][j]) {
                    res += 1;
                } else {
                    res = 0;
                }
            }
        }
        if (res == array.length * array.length) {
            res = 1;
        } else {
            res = 0;
        }
        System.out.print(res + " ");
        System.out.println();
    }

    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        int n = in.nextInt();
        if (1<= n && n <= 100) {
            int[][] fRelstion = new int[n][n];
            int[][] sRelation = new int[n][n];
            int[][] composition = new int[n][n];
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    fRelstion[i][j] = in.nextInt();
                }
            }
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    sRelation[i][j] = in.nextInt();
                }
            }
            System.out.println();
            compare(fRelstion);
            compare(sRelation);
            System.out.println();

            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    for (int k = 0; k < n; k++) {
                        composition[i][j] += fRelstion[i][k] * sRelation[k][j];
                    }
                }
            }
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    if (composition[i][j] > 1) {
                        composition[i][j] = 1;
                    }
                    System.out.print(composition[i][j] + " ");
                }
                System.out.println();
            }
        }
    }
}

