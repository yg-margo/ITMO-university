package md2html;

record HeadlineParser(StringBuilder source) {

    private int headerLevel(StringBuilder text) {
        int pos = 0;
        while (pos < text.length() && text.charAt(pos) == '#') {
            pos++;
        }
        return pos;
    }

    public void toHtml(StringBuilder res) {
        int level = headerLevel(source);
        res.append("<h").append(level).append(">");
        new ParserTxt(
                new StringBuilder(source.substring(level + 1))).toHtml(res);
        res.append("</h").append(level).append(">");
    }
}
