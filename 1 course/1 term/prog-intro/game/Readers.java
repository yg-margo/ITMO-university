package game;

import java.io.*;
import java.util.*;

public class Readers {

    public boolean isNumber(String y) {
        for (int i = 0; i < y.length(); i++) {
            if (!Character.isDigit(y.charAt(i))) {
                return false;
            }
        }
        return !y.isEmpty();
    }

    public int getInt(Scanner in, PrintStream out, String caller) {
        out.print("Enter " + caller + " without extra symbols: ");
        while (true) {
            String y = in.nextLine();
            if (isNumber(y)) {
                int num = Integer.parseInt(y);
                if (num > 0) return num;
            }
            out.print("Enter " + caller + " again: ");
        }
    }
}
