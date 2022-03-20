import java.io.*;
import java.util.function.Function;

public class MyScanner implements AutoCloseable {

    private final BufferedReader reader;
    private int cntLines = 0;

    public MyScanner(BufferedReader reader) {
        this.reader = reader;
    }

    public MyScanner(String strings) {
        this(new BufferedReader(new StringReader(strings)));
    }

    public MyScanner(InputStream inputStream) {
        this(new BufferedReader(new InputStreamReader(inputStream)));
    }

    public MyScanner(FileReader fileReader) {
        this(new BufferedReader(fileReader));
    }

    public int getLineNumber() {
        return cntLines;
    }

    public String next(Function<Integer, Boolean> mask) throws IOException {
        int chars = -1;
        while ((chars = reader.read()) != -1 && !mask.apply(chars)) {
            if (chars == '\n') cntLines++;
        }
        if (chars == -1) return null;
        StringBuilder answer = new StringBuilder();
        answer.appendCodePoint(chars);
        while ((chars = reader.read()) != -1 && mask.apply(chars)) {
            if (chars == '\n')  cntLines++;
            answer.appendCodePoint(chars);
        }
        return answer.toString();
    }

    public String next() throws IOException {
        return next(c -> !Character.isWhitespace(c));
    }

    public int nextInt() throws IOException {
        return Integer.parseInt(next(c -> (Character.isDigit(c) || c == '-')));
    }

    public String nextLine() throws IOException {
        cntLines++;
        return reader.readLine();
    }

    public void close() throws IOException {
        reader.close();
    }
}