let
  pins = import ./npins;
  nilla = import pins.nilla;
in
nilla.create (
  { config }:
  let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  in
  {
    config = {
      inputs = {
        nixpkgs = {
          src = pins.nixpkgs;
          loader = "flake";
        };
        home-manager.src = pins.home-manager;
        pre-commit-hooks.src = pins.pre-commit-hooks;
      };
      shells.default = {
        inherit systems;
        shell =
          { pkgs, ... }:
          pkgs.mkShell {
            packages = [ pkgs.hello ];
          };
      };
      lib.denilla = let
        nixpkgs = config.inputs.nixpkgs.result;
        home-manager = config.inputs.home-manager.result;
      in import ./lib {
        inherit (nixpkgs) lib;
        inherit nixpkgs home-manager;
      };
    };
  }
)
