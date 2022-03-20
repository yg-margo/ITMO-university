import java.util.ArrayList;
import java.util.Collections;
import java.util.Scanner;

public class C {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        StringBuilder bild = new StringBuilder(sc.nextLine());
        int letters = bild.length();
        ArrayList<StringBuilder> lst = new ArrayList<>(letters);
        for (int i = 0; i < letters; i++) {
            lst.add(new StringBuilder());
        }
        for (int i = 0; i < lst.size(); i++) {
            for (int j = 0; j < lst.size(); j++)
                lst.get(j).insert(0, bild.charAt(j));
            Collections.sort(lst);
          }
          
        System.out.println(lst.get(0));
    }
}