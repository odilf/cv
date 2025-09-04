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

        font-to-static = pkgs.writeShellApplication {
          name = "font-to-static";
          runtimeInputs = [ pkgs.python3Packages.fonttools ];
          text = ''
            src="$1"
            name="$(basename "$src" '.ttf')"
            for wght in 100 200 300 400 500 600 700 800 900; do
              fonttools varLib.mutator -o "$name-$wght.ttf" "$src" wght="$wght"
            done
          '';
        };
        lora-static = pkgs.lora.overrideAttrs (
          finalAttrs: prevAttrs: {
            nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ font-to-static ];
            preFixup = ''
              find "$out" -name '*.ttf' -execdir font-to-static '{}' ';'
            '';
          }
        );
      in
      {
        formatter = pkgs.nixfmt-rfc-style;

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.typst
            pkgs.tinymist
            pkgs.typstfmt
            font-to-static
            lora-static
            pkgs.just
          ];
        };
      }
    );
}
