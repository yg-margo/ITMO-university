package md2html;

record ParagraphParser(StringBuilder source) {

    public void toHtml(StringBuilder res) {
        res.append("<p>");
        new ParserTxt(source).toHtml(res);
        res.append("</p>");
    }
}
