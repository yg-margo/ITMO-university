package markup;

import java.util.List;

public class AbstractClass implements Marks {
    List<Marks> list;
    String toMark, toBB1, toBB2;

    public AbstractClass(List<Marks> list, String toMark, String toBB1, String toBB2) {
        this.list = list;
        this.toMark = toMark;
        this.toBB1 = toBB1;
        this.toBB2 = toBB2;
    }

    public AbstractClass() {

    }

    public void toMarkdown(StringBuilder ans) {
        ans.append(toMark);
        for (Marks cur : list) {
            cur.toMarkdown(ans);
        }
        ans.append(toMark);
    }

    public void toBBCode(StringBuilder ans) {
        ans.append(toBB1);
        for (Marks cur : list) {
            cur.toBBCode(ans);
        }
        ans.append(toBB2);
    }
}
