{
  description = "envfetch by locomiadev";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        packages = {
          default = pkgs.stdenv.mkDerivation {
            name = "envfetch";
            src = ./.;
            installPhase = ''
              ENVFETCH_BIN=$out/bin/envfetch \
              ENVFETCH_DIR=$out/etc \
              ./install.sh install
            '';
          };
        };
        apps = {
          default = flake-utils.lib.mkApp {
            drv = self.packages.${system}.default;
          };
        };
      }
    );
}
