package game;

/**
 * @author Georgiy Korneev (kgeorgiy@kgeorgiy.info)
 */
public interface Position {
    boolean isValid(Move move);
    int getRowSize();
    int getColSize();
    Cell getCell(int y, int x);
}
