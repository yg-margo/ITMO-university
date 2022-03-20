import java.io.*;
import java.lang.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class Wspp {
    public static boolean isWordPart(char ch) {
        return (Character.isLetter(ch) || Character.getType(ch) ==
                        Character.DASH_PUNCTUATION || ch == '\'');
    }
    public static void main(String[] args) throws FileNotFoundException {
        String strg, word;
        ArrayList <String> arrList = new ArrayList<>();
        HashMap<String, ArrayList<Integer>> words = new LinkedHashMap<>();
        int i, j;
        int cnt = 0;
        BufferedReader r = new BufferedReader(
                new InputStreamReader(
                        new FileInputStream(args[0]), StandardCharsets.UTF_8));
        BufferedWriter w = new BufferedWriter(
                new OutputStreamWriter(
                        new FileOutputStream(args[1]), StandardCharsets.UTF_8));
        try {
            try  {
                Scanner s = new Scanner(r);
                while (s.hasNextLine()) {
                    strg = s.nextLine() + " ";
                    for (i = 0; i < strg.length(); i++) {
                        if (!isWordPart(strg.charAt(i))) continue;
                        j = i;
                        while (isWordPart(strg.charAt(i))) {
                            i++;
                        }
                        word = strg.substring(j, i).toLowerCase();
                        cnt++;
                        if (!words.containsKey(word)) words.put(word,
                                new ArrayList<>(List.of(0)));
                        List<Integer> lst = words.get(word);
                        if (lst.get(0) == 0) arrList.add(word);
                        lst.set(0, words.get(word).get(0) + 1);
                        lst.add(cnt);
                    }
                }
            } finally {
                r.close();
            }
            try {
                for (String element : arrList) {
                    w.write(element);
                    for (Integer amo : words.get(element)) {
                        w.write(" " + amo);
                    }
                    w.write("\n");
                }
            } finally {
                w.close();
            }
        } catch (IOException e) {
            System.out.println("Unable to read/write" + e.getMessage());
        }
    }
}
