{
  description = "virtual environments";

  inputs.devshell.url = "github:numtide/devshell";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, flake-utils, devshell, nixpkgs }:
    flake-utils.lib.eachSystem [flake-utils.lib.system.x86_64-linux] (system:
        let
          pkgs = import nixpkgs {
            inherit system;

            overlays = [ devshell.overlays.default ];
          };
        in
    {
      devShells = rec {
        devshell = pkgs.devshell.mkShell {
        };
        default = devshell;
      };

      packages = rec {
        opentrack = pkgs.libsForQt5.callPackage ./default.nix {
          src = self; version = self.shortRev or "dirty";
          wine = pkgs.wine64;
        };

        opentrack-up = pkgs.libsForQt5.callPackage ./default.nix rec {
          version = "2022.3.0";
          src = pkgs.fetchFromGitHub {
              owner = "opentrack";
              repo = "opentrack";
              rev = "opentrack-${version}";
              sha256 = "sha256-8gpNORTJclYUYp57Vw/0YO3XC9Idurt0a79fhqx0+mo=";
          };
          wine = pkgs.wine64;
        };


        default = opentrack;
      };
    });
}
