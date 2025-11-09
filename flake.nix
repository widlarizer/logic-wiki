{
  description = "Sphinx documentation with book and wiki outputs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          sphinx
          myst-parser
          sphinxcontrib-bibtex
          sphinx-rtd-theme
        ]);
      in
      {
        packages = {
          book = pkgs.stdenv.mkDerivation {
            name = "sphinx-book";
            src = ./.;
            buildInputs = [ pythonEnv pkgs.texlive.combined.scheme-medium ];
            buildPhase = ''
              cd source
              sphinx-build -b latex -t book . ../build/book
              cd ../build/book
              make
            '';
            installPhase = ''
              mkdir -p $out
              cp *.pdf $out/
            '';
          };

          wiki = pkgs.stdenv.mkDerivation {
            name = "sphinx-wiki";
            src = ./.;
            buildInputs = [ pythonEnv ];
            buildPhase = ''
              cd source
              sphinx-build -b html -t wiki . ../build/wiki
            '';
            installPhase = ''
              mkdir -p $out
              cp -r ../build/wiki/* $out/
            '';
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pythonEnv
            pkgs.texlive.combined.scheme-medium
            pkgs.texlivePackages.fncychap
          ];
          shellHook = ''
            echo "Sphinx documentation environment loaded"
            echo "Build book: cd source && sphinx-build -b latex -t book . ../build/book && cd ../build/book && make"
            echo "Build wiki: cd source && sphinx-build -b html -t wiki . ../build/wiki"
          '';
        };
      }
    );
}
