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
          wine = pkgs.wine64;
        };
        default = opentrack;
      };
    });
}
