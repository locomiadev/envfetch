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
            buildInputs = [ pkgs.makeWrapper ];
            installPhase = ''
              mkdir -p $out/bin
              mkdir -p $out/etc
              cp -r ascii $out/etc/ascii
              cp main.sh $out/bin/envfetch
              chmod +x $out/bin/envfetch
            '';
            postFixup = ''
              wrapProgram $out/bin/envfetch \
                --chdir "$out/etc"
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
