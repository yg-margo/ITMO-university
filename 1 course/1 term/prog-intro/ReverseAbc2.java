import java.io.IOException;

public class ReverseAbc2 {
    private static final int MAX_ARRAY_CAPACITY = 10_000_000;
    private static final char ABC_TO_INT = (char) ('a' - '0');
    public static void main(String[] args) {
        int[] nums = new int[MAX_ARRAY_CAPACITY];
        int[] cnt = new int[MAX_ARRAY_CAPACITY];
        int size = 0, cntSize = 0;

        try (MyScanner sc = new MyScanner(System.in)) {
            String num;
            int cntNumber = 0;
            int beforeL = sc.getLineNumber();
            while ((num = sc.next()) != null) {
                int currentLine = sc.getLineNumber();
                if (beforeL != currentLine) {
                    cnt[beforeL] = cntNumber;
                    cntNumber = 0;
                }
                nums[size++] = abcToInt(num);
                cntNumber++;
                beforeL = currentLine;
            }
            cntSize = sc.getLineNumber();
            cnt[beforeL] = cntNumber;

        } catch (IOException e) {
            e.printStackTrace();
        }

        int index = size - 1;
        for (int i = cntSize - 1; i >= 0; i--) {
            for (int j = cnt[i] - 1; j >= 0; j--) {
                System.out.print(nums[index--] + " ");
            }
            System.out.println();
        }
    }

    private static int abcToInt(String str) {
        boolean neg = false;
        int i = 0;
        if (str.charAt(0) == '-') {
            neg = true;
            i = 1;
        }
        int result = 0;
        for (int end = str.length(); i < end; i++) {
            result = (result * 10) +
                    (str.charAt(i) - 'a');
        }
        return neg ? -result : result;
    }
}
