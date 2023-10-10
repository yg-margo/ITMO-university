import java.util.Scanner;

public class H {

    public static void main(String[] args) {
        Scanner sc1 = new Scanner(System.in);
        int n = sc1.nextInt();

        String str0 = "((A0|B0)|(A0|B0))";
        if (n == 0) {
            System.out.print(str0);
        } else {
            for (int i = 1; i < n; i++) {
                String str1 = "(" + str0 + "|((A" + i + "|A" + i + ")|(B" + i + "|B" + i + "))" + ")";
                str0 = "(" + str1 + "|(A" + i + "|B" + i + ")" + ")";
            }
            System.out.print(str0);
        }
    }
}
