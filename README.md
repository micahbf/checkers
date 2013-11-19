checkers
========

Checkers is a CLI-based implementation of the game checkers.

To try it out:

1. Clone the repo
2. `gem install colorize`
3. `./checkers.rb`

Checkers uses a minimax tree for AI. Specifically, it uses a *negamax tree with alpha-beta pruning*.

For every move, the computer builds out a move tree, where each node of the tree contains a board state.
Starting from the current board state, it builds out a tree for each of its possible moves, and then from each
of those it builds out all of the opponents possible moves, and then again its responses to those responses and so
on, to the specified depth. It then evaluates the board state for each of the leaves, using alpha-beta pruning to
skip branches when possible.

Board evaluation is somewhat simplistic at the moment. The board is evaluated with a simple per-piece point system:

* 1 point for every piece on the board
* 0.5 extra if the piece is a king
* 0.2 extra if the piece is on the side of the board (i.e. protected)

The same values are subtracted for each of the opponent's pieces (hence *negamax*).
