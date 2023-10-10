import java.io.IOException;

public class Reverse {
    private static final int MAX_ARRAY_CAPACITY = 10_000_000;
    public static void main(String[] args) {
        int[] nums = new int[MAX_ARRAY_CAPACITY];
        int[] cnt = new int[MAX_ARRAY_CAPACITY];
        int size = 0, cntSize = 0;

        try (MyScanner sc = new MyScanner(System.in)) {
            String num;
            int cntNumber = 0;
            int beforeL = sc.getLineNumber();
            while ((num = sc.next()) != null) {
                int cur = sc.getLineNumber();
                if (beforeL != cur) {
                    cnt[beforeL] = cntNumber;
                    cntNumber = 0;
                }
                nums[size++] = Integer.parseInt(num);
                cntNumber++;
                beforeL = cur;
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
            System.out.print(System.lineSeparator());
        }
    }
}
