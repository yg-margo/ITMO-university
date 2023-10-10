package game;

import java.io.PrintStream;
import java.util.Arrays;
import java.util.Map;
import java.util.Scanner;

/**
 * @author Georgiy Korneev (kgeorgiy@kgeorgiy.info)
 */
public class MNKBoard extends Readers implements Board, Position {
    private static final Map<Cell, Character> SYMBOLS = Map.of(
            Cell.X, 'X',
            Cell.O, 'O',
            Cell.E, '.'
    );

    private final Cell[][] cells;
    private Cell turn;
    private final int rowSize;
    private final int colSize;
    private final int k;
    private final PrintStream out;
    private final Scanner in;

    public MNKBoard(final PrintStream out, final Scanner in) {
        this.out = out;
        this.in = in;
        this.rowSize = getInt(in, out, "Row size");
        this.colSize = getInt(in, out, "Col size");
        int k = getInt(in, out, "K");

        while (k > getColSize() && k > getRowSize()) {
            out.println("Impossible K");
            k = getInt(in, out, "K");
        }
        this.k = k;
        this.cells = new Cell[rowSize][colSize];
        for (Cell[] row : cells) {
            Arrays.fill(row, Cell.E);
        }
        turn = Cell.X;
    }

    public MNKBoard() {
        this(System.out, new Scanner(System.in));
    }

    @Override
    public Position getPosition() {
        return this;
    }

    @Override
    public Cell getCell() {
        return turn;
    }

    @Override
    public Result makeMove(final Move move) {
        if (!isValid(move)) {
            return Result.LOSE;
        }
        cells[move.getRow()][move.getColumn()] = move.getValue();
        int empty = 0;
        for (int ii = 0; ii < getRowSize(); ii++) {
            for (int jj = 0; jj < getColSize(); jj++) {
                if (cells[ii][jj] == Cell.E) {
                    empty++;
                }
                int r1 = 0;
                int r2 = 0;
                int col1 = 0;
                int col2 = 0;
                int d1 = 0;
                int d2 = 0;
                int d3 = 0;
                int d4 = 0;
                for (int i = 0; i < k; i++) {
                    if (ii + i < getRowSize() && cells[ii + i][jj] == turn) {
                        r1++;
                    }
                    if (ii - i >= 0 && cells[ii - i][jj] == turn) {
                        r2++;
                    }
                    if (jj + i < getColSize() && cells[ii][jj + i] == turn) {
                        col1++;
                    }
                    if (jj - i >= 0 && cells[ii][jj - i] == turn) {
                        col2++;
                    }
                    if (ii + i < getRowSize() && jj + i < getColSize() && cells[ii + i][jj + i] == turn) {
                        d1++;
                    }
                    if (ii + i < getRowSize() && jj - i >= 0 && cells[ii + i][jj - i] == turn) {
                        d2++;
                    }
                    if (ii - i >= 0 && jj + i < getColSize() && cells[ii - i][jj + i] == turn) {
                        d3++;
                    }
                    if (ii - i >= 0 && jj - i >= 0 && cells[ii - i][jj - i] == turn) {
                        d4++;
                    }
                }
                if (r1 == k || r2 == k || col1 == k || col2 == k || d1 == k || d2 == k || d3 == k || d4 == k) {
                    return Result.WIN;
                }
            }
        }
        if (empty == 0) {
            return Result.DRAW;
        }
        turn = turn == Cell.X ? Cell.O : Cell.X;
        return Result.UNKNOWN;
    }

    @Override
    public boolean isValid(final Move move) {
        return 0 <= move.getRow() && move.getRow() < rowSize
                && 0 <= move.getColumn() && move.getColumn() < colSize
                && cells[move.getRow()][move.getColumn()] == Cell.E
                && turn == getCell();
    }

    @Override
    public void clear(){
        for (Cell[] row : cells) {
            Arrays.fill(row, Cell.E);
        }
    }

    @Override
    public int getRowSize() {
        return rowSize;
    }

    @Override
    public int getColSize() {
        return colSize;
    }

    @Override
    public Cell getCell(final int r, final int c) {
        return cells[r][c];
    }

    @Override
    public String toString() {
        final StringBuilder buf = new StringBuilder(" ");
        for (int i = 0; i < colSize; i++) {
            buf.append(i + 1);
        }
        for (int r = 0; r < getRowSize(); r++) {
            buf.append("\n");
            buf.append(r + 1);
            for (int c = 0; c < getColSize(); c++) {
                buf.append(SYMBOLS.get(cells[r][c]));
            }
        }
        return buf.toString();
    }
}
