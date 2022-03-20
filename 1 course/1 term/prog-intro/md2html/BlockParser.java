package md2html;

record BlockParser(StringBuilder source) {

    private boolean isHeader(StringBuilder text) {
        int pos = 0;
        while (pos < text.length() && text.charAt(pos) == '#') {
            pos++;
        }
        return pos > 0 && pos < text.length() && text.charAt(pos) == ' ';
    }

    public void toHtml(StringBuilder res) {
        if (isHeader(source)) {
            new HeadlineParser(source).toHtml(res);
        } else {
            new ParagraphParser(source).toHtml(res);
        }
    }
}
