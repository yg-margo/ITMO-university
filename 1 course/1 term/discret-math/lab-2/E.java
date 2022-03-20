import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

public class E {

    public static void main(String[] args) throws IOException {
        Scanner scanner = new Scanner(System.in);
        String s = scanner.nextLine();
        ArrayList<String> dict = new ArrayList<>();
        for (int i = 0; i < 26; i++) {
            dict.add((char) (i + 97) + "");
        }
        String t = "";
        for (int i = 0; i < s.length(); i++) {
            String c = s.charAt(i) + "";
            if (dict.indexOf(t + c) != -1) {
                t = t + c;
            } else {
                System.out.print(dict.indexOf(t) + " ");
                dict.add(t + c);
                t = c;

            }
        }
        System.out.print(dict.indexOf(t) + " ");
    }
}