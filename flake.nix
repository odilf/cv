{
  description = "Hexagonal chess";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        formatter = pkgs.nixfmt-rfc-style;

        devShells = {
          default = pkgs.mkShellNoCC {
            packages = [
              pkgs.typst
              pkgs.tinymist
              pkgs.typstfmt
              pkgs.just
            ];

            TYPST_FONT_PATHS = pkgs.symlinkJoin {
              name = "typst-fonts";
              paths = [
                pkgs.lora
              ];
            };
          };

          ci = pkgs.mkShellNoCC {
            packages = [
              pkgs.typst
            ];

            TYPST_FONT_PATHS = pkgs.symlinkJoin {
              name = "typst-fonts";
              paths = [
                pkgs.lora
              ];
            };
          };
        };
      }
    );
}
