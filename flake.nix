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
        sphinx = (sphinx.overrideAttrs ( old : {
          version = old.version + "-nothebib";
          src = pkgs.fetchFromGitHub {
            owner = "widlarizer";
            repo = "sphinx";
            rev = "27678e0e213fe552b39ca830d05a722eb2b56be4";
            postFetch = ''
              # Change ä to æ in file names, since ä can be encoded multiple ways on different
              # filesystems, leading to different hashes on different platforms.
              cd "$out";
              mv tests/roots/test-images/{testimäge,testimæge}.png
              sed -i 's/testimäge/testimæge/g' tests/{test_build*.py,roots/test-images/index.rst}
            '';
            hash = "sha256-YWJ0cv2WPNtr2v3m+RtsLKWIo9o6xS6KQzySuWoYPEQ=";
          };
          disabledTests = old.disabledTests ++ [ "test_latex_thebibliography" ];
        }));

        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          myst-parser
          sphinxcontrib-bibtex
          furo.override { inherit sphinx; }
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
            capt-of
            pict2e
            ellipse
            ;
        })];
        buildSphinx = { name, installPhase, format, tag, extraInputs ? [], extraSteps ? "" }:
          pkgs.stdenv.mkDerivation {
            inherit name;
            inherit installPhase;
            src = ./.;
            buildInputs = [ pkgs.bash pythonEnv ] ++ extraInputs;
            buildPhase = ''
              sphinx-build -b ${format} -t ${tag} source build/${tag} -W
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
              cp _templates/logicbook.cls build/book/
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