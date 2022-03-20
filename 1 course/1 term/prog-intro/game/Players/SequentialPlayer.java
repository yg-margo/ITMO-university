package game.Players;

import game.Cell;
import game.Move;
import game.Player;
import game.Position;

/**
 * @author Georgiy Korneev (kgeorgiy@kgeorgiy.info)
 */
public class SequentialPlayer implements Player {
    @Override
    public Move move(final Position position, final Cell cell) {
        for (int y = 0; y < position.getRowSize(); y++) {
            for (int x = 0; x < position.getColSize(); x++) {
                final Move move = new Move(y, x, cell);
                if (position.isValid(move)) {
                    return move;
                }
            }
        }
        throw new IllegalStateException("No valid moves");
    }
}
