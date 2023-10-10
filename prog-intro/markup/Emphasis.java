package markup;

import java.util.List;

public class Emphasis extends AbstractClass {
    public Emphasis(List<Marks> list) {
        super(list, "*", "[i]", "[/i]");
    }
}
