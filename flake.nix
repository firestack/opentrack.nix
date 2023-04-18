{
  description = "virtual environments";

  inputs.devshell.url = "github:numtide/devshell";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, flake-utils, devshell, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system: 
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
        opentrack = pkgs.libsForQt5.callPackage ./default.nix {};
        default = opentrack;
      };
    });
}
