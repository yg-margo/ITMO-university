package markup;

public class Text extends AbstractClass {
    String text;

    public Text(String text) {
        super();
        this.text = text;
    }

    @Override
    public void toMarkdown(StringBuilder ans) {
        ans.append(text);
    }

    public void toBBCode(StringBuilder ans) {
        ans.append(text);
    }
}
