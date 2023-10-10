package game;

import java.io.*;
import java.util.*;

public class Tournament extends Readers {
    private int x;
    private int[] results;
    private final PrintStream out;
    private final Scanner in;
    private Board board;
    private Player[] players;

    public Tournament(final PrintStream out, final Scanner in) {
        this.out = out;
        this.in = in;
        this.x = getInt(in, out, "number of circles");
        this.board = new MNKBoard();
    }

    public Tournament() {
        this(System.out, new Scanner(System.in));
    }

    public void setPlayers(Player... player) {
        this.players = player;
        this.results = new int[player.length];
    }

    public void playTournament() {
        for (int z = 0; z < this.x; z++) {
            for (int i = 0; i < players.length; i++) {
                for (int j = i + 1; j < players.length; j++) {
                    final Game game = new Game(true, players[i], players[j]);
                    int result = game.play(board);
                    if (result == 0) {
                        results[i] += 1;
                        results[j] += 1;
                    } else if (result == 1) {
                        results[i] += 3;
                    } else if (result == 2) {
                        results[j] += 3;
                    }
                    board.clear();
                }
            }
        }
        printResult();
    }

    public void printResult() {
        out.println("RESULTS");
        for (int i = 0; i < results.length; i++) {
            out.println("Player " + (i + 1) + ": " + results[i] + " points");
        }
    }
}
