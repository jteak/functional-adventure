# Functional Adventure Games
An adventure game player implemented in OCaml and functional programming.

*Authors: Al Palanuwech, Goay Wei Gee, Justin Eakthunyasakul, Nicholas Rahardja*

## Features
- **Play any compatible game**

The player is already preloaded with a game, which consists of `adventure_game.json` and `charmove_game.json` in the `json` folder. `adventure_game.json` contains the rooms in the game, and `charmove_game.json` contains the characters and their moves. However, you can replace the two files with games of your own; just make sure the name of the files stay the same (or, if you are feeling adventurous, you can edit where the player fetches the games at the top of `main.ml`). See the included game files for the schema.

- **Singleplayer and multiplayer support**

Play alone in story mode, where you will traverse locations, fight enemies, earn gold to buy items, and increase your XP to fight tougher enemies. Or take turns at the keyboard with a friend and play multiplayer mode, where each player can assemble their team of characters in the game and fight each other.

- **Elements, cooldowns, and items**

Each character has an element, which varies the effectiveness of its attacks depending on the element of the target. After attacking, it will have a cooldown period where other characters must be used instead to increase variety. Use purchased items to heal and revive characters.

- **Save your progress**

After playing the game for a while, you will have the option to save your progress in the game as a JSON file to be reloaded later.

## Installation
The game must be compiled, so [**OPAM**](https://opam.ocaml.org/doc/Install.html) and packages [**Yojson**](https://github.com/ocaml-community/yojson) and [**ANSITerminal**](https://github.com/Chris00/ANSITerminal) are required to run the game. Once those prerequisites are installed, run `make build` then `make play` to start the game.

For debugging, you will also need [**OUnit2**](https://github.com/gildor478/ounit). To run the test script (`test.ml`), run `make test`. `adventure_test.json` and `charmove.json` are used in the test script. (Apologies for the inconsistent naming!)
