import java.io.*;
import java.lang.Character;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class WsppPosition {
    public static boolean isWordPart(char ch) {
        return (Character.isLetter(ch) || Character.getType(ch) ==
                        Character.DASH_PUNCTUATION || ch == '\'');
    }
    public static void main(String[] args) throws FileNotFoundException {
        String strg, word;
        HashMap<String, ArrayList<Integer>> arrList = new LinkedHashMap<>();
        int i, j;
        int cnt;
        int lineOfNumbers = 0;
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
                    cnt = 0;
                    lineOfNumbers++;
                    strg = s.nextLine() + " ";
                    for (i = 0; i < strg.length(); i++) {
                        if (!isWordPart(strg.charAt(i))) continue;
                        j = i;
                        while (isWordPart(strg.charAt(i))) {
                            i++;
                        }
                        word = strg.substring(j, i).toLowerCase();
                        cnt++;
                        if (!arrList.containsKey(word)) arrList.put(word, new ArrayList<>(List.of(0)));
                        List<Integer> lst = arrList.get(word);
                        lst.set(0, lst.get(0) + 1);
                        lst.add(lineOfNumbers);
                        lst.add(cnt);
                    }
                }
            } finally {
                r.close();
            }
            try {
                for (String element : arrList.keySet()) {
                    w.write(element);
                    List<Integer> amo = arrList.get(element);
                    w.write(" " + amo.get(0));
                    for (i = 1; i < amo.size(); i += 2) {
                        w.write(" " + amo.get(i) + ":" + amo.get(i + 1));
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
