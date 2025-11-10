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

        texEnv = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-basic
            fncychap
            titlesec
            tabulary
            varwidth
            framed
            fancyvrb
            float
            wrapfig
            parskip
            upquote
            capt-of
            needspace
            hypcap
            collection-fontsrecommended
            collection-latexrecommended;
        };
        buildSphinx = { name, format, tag, extraInputs ? [], extraSteps ? "" }:
          pkgs.stdenv.mkDerivation {
            inherit name;
            src = ./.;
            buildInputs = [ pythonEnv ] ++ extraInputs;
            buildPhase = ''
              sphinx-build -b ${format} -t ${tag} source build/${tag}
              ${extraSteps}
            '';
            installPhase = ''
              mkdir -p $out
              cp -r build/${tag}/* $out/
            '';
          };
      in
      {
        packages = {
          book = buildSphinx {
            name = "sphinx-book";
            format = "latex";
            tag = "book";
            extraInputs = texEnv;
            extraSteps = ''
              cd build/book && make
              rm -rf !(*.pdf)
            '';
          };

          wiki = buildSphinx {
            name = "sphinx-wiki";
            format = "html";
            tag = "wiki";
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ pythonEnv ] ++ texEnv;
          shellHook = ''
            echo "Sphinx documentation environment loaded"
            echo "Build book: nix build .#book"
            echo "Build wiki: nix build .#wiki"
          '';
        };
      }
    );
}