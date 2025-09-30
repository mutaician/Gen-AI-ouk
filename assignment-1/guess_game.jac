import random;

walker GuessGame {
    has correct_number: int = random.randint(1,10);

    can start_game with `root entry;
    def process_guess(guess: int);
}

node turn {
    can check with GuessGame entry;
}

with entry {
    GuessGame() spawn root;
}


# declaring fields with `has` keyword with object definition
# separating implementation with `impl` - basically creating a .impl.jac file with impl

# Jac's object-spatial architecture, something lika a graph
# chain of `turn` nodes created with ++>, move with `visit [-->]` and stop via `disengage`, launched via `spawn` at root