package md2html;

import java.util.*;

public record ParserTxt(StringBuilder source) {
    private static final Map<String, Integer> index;
    private static final String[] Html;
    private static final String[] tags;

    static {
        Html = new String[]{"em", "strong", "em", "strong", "s", "code", "var"};
        tags = new String[]{"*", "**", "_", "__", "--", "`", "%"};
        int cnt = tags.length;
        index = new HashMap<>();
        for (int i = 0; i < cnt; i++) {
            index.put(tags[i], i);
        }
    }

    private Integer getTagPosition(String c) {
        Integer res = index.get(c);
        if (res == null) {
            res = index.get(Character.toString(c.charAt(0)));
        }
        return res;
    }

    public void toHtml(StringBuilder res) {
        int cnt = Html.length;
        IntList[] arr = new IntList[cnt];
        for (int i = 0; i < cnt; i++) {
            arr[i] = new IntList();
        }
        for (int i = 0; i < source.length(); i++) {
            String c = source.substring(i, Math.min(i + 2, source.length()));
            if (source.charAt(i) == '\\') {
                i++;
                continue;
            }
            Integer pos = getTagPosition(c);
            if (pos != null) {
                arr[pos].add(i);
            }
        }
        for (IntList intList : arr) {
            if (intList.getSize() % 2 == 1) {
                intList.pop();
            }
        }
        int[] pos = new int[cnt];
        for (int i = 0; i < source.length(); i++) {
            char cr = source.charAt(i);
            String c = source.substring(i, Math.min(i + 2, source.length()));
            switch (cr) {
                case '<' -> {
                    res.append("&lt;");
                    continue;
                }
                case '>' -> {
                    res.append("&gt;");
                    continue;
                }
                case '&' -> {
                    res.append("&amp;");
                    continue;
                }
                case '\\' -> {
                    if (i + 1 < source.length()) {
                        res.append(source.charAt(++i));
                    }
                    continue;
                }
            }
            Integer pos1 = getTagPosition(c);
            if (pos1 == null || arr[pos1].getSize() == 0) {
                res.append(cr);
            } else {
                c = tags[pos1];
                String name = Html[pos1];
                int size = c.length();
                boolean isOpen = ((arr[pos1].getSize() - pos[pos1]) % 2 == 0);
                String t = "<" + (isOpen ? "" : "/") + name + ">";
                res.append(t);
                i += size - 1;
                pos[pos1]++;
            }
        }
    }
}
