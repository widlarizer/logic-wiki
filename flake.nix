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

        texEnv = [ (pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-basic
            latexmk
            fncychap
            tex-gyre
            tex-gyre-math
            xcolor
            wrapfig
            needspace
            varwidth
            booktabs
            collection-fontsrecommended
            cmap
            titlesec
            tabulary
            framed
            fancyvrb
            float
            parskip
            upquote
            capt-of;
        })];
        buildSphinx = { name, installPhase, format, tag, extraInputs ? [], extraSteps ? "" }:
          pkgs.stdenv.mkDerivation {
            inherit name;
            inherit installPhase;
            src = ./.;
            buildInputs = [ pkgs.bash pythonEnv ] ++ extraInputs;
            buildPhase = ''
              sphinx-build -b ${format} -t ${tag} source build/${tag}
              ${extraSteps}
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
              make -C build/book
            '';
            installPhase = ''
              mkdir -p $out
              cp build/book/*.pdf $out/
            '';
          };

          wiki = buildSphinx {
            name = "sphinx-wiki";
            format = "html";
            tag = "wiki";
            installPhase = ''
              mkdir -p $out
              ls build/wiki
              cp -r build/wiki/* $out/
            '';
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ pkgs.bash pythonEnv ] ++ texEnv;
          shellHook = ''
            echo "Sphinx documentation environment loaded"
          '';
        };
      }
    );
}