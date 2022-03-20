package game;

import game.Players.RandomPlayer;

/**
 * @author Georgiy Korneev (kgeorgiy@kgeorgiy.info)
 */
public class Main {
    public static void main(String[] args) {
        for (int i = 0; i < 1000; i++) {
            final Tournament championship = new Tournament();
            championship.setPlayers(new RandomPlayer(), new RandomPlayer(), new RandomPlayer());
            championship.playTournament();
        }
    }
}
