package markup;

import java.util.List;

public class Strikeout extends AbstractClass {
    public Strikeout(List<Marks> list) {
        super(list, "~", "[s]", "[/s]");
    }
}
