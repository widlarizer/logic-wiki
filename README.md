# Logic wiki

This is the basis for an open knowledge base for learning about digital logic and particularly the implementation of VLSI EDA. Currently, it only contains placeholder text until typesetting and publishing is figured out. It's built with [Sphinx](https://www.sphinx-doc.org/) in [MyST markdown](https://myst-parser.readthedocs.io/).

## Build

### With Nix

Run `nix build .#book` to build a book PDF or `nix build .#wiki` to build wiki HTML in `result/`. Running `nix build .#wiki .#book` will create both in `result/` and `result-1/`.

### Without Nix

Ponder `flake.nix`. From this, you can figure out how on your linux distribution or other environment you can get the same packages. You can then do `sphinx-build -b latex -t book source build/book && make -C build/book` or `sphinx-build -b html -t wiki source build/wiki`.
