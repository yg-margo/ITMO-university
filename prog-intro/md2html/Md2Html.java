package md2html;

import java.io.*;
import java.nio.charset.StandardCharsets;

public class Md2Html {

    public static void main(String[] args) {
        if (args.length != 2) {
            System.err.println("Missed filenames\n");
            return;
        }
        StringBuilder res = new StringBuilder();
        try {
            try (BufferedReader r = new BufferedReader(
                    new InputStreamReader(
                            new FileInputStream(args[0]),
                            StandardCharsets.UTF_8))) {
                String l = "";
                StringBuilder par = new StringBuilder();
                while (l != null && (l = r.readLine()) != null) {
                    while (l != null && !l.isEmpty()) {
                        par.append(l).append('\n');
                        l = r.readLine();
                    }
                    if (par.length() != 0) {
                        par.setLength(par.length() - 1);
                        new BlockParser(par).toHtml(res);
                        res.append('\n');
                        par = new StringBuilder();
                    }
                }
            }
        } catch (FileNotFoundException e) {
            System.err.println("Input file not found: " + e.getMessage());
        } catch (IOException e) {
            System.err.println("Read error: " + e.getMessage());
        }
        try {
            try (BufferedWriter w = new BufferedWriter(
                    new OutputStreamWriter(
                            new FileOutputStream(args[1]),
                            StandardCharsets.UTF_8))) {
                w.write(res.toString());
            }
        } catch (FileNotFoundException e) {
            System.err.println("Output file not found: " + e.getMessage());
        } catch (IOException e) {
            System.err.println("Write error: " + e.getMessage());
        }
    }
}
