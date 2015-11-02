# Chess

This is a command line implementation of Chess written in Ruby. The visual formatting may not render properly on non-Mac machines. I use recursion to build move-trees for each piece based on the current configuration of the board, and highlight the available moves for each piece when it is selected. I perform a deep-dup on the board to test for checkmate.

# Screenshot

This screenshot shows the visual appeal of the game and demonstrates the available move-highlighting feature.

![alt tag](screenshots/game.png)

# To-Do's

- [ ] Refactor
- [ ] Allow for deselecting pieces
- [ ] Enforce current player move restrictions
