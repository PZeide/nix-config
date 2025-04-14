{
  system,
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options.zeide.nix = with lib; {
    useLix = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to use Lix nix package manager.
        See: https://lix.systems/
      '';
    };

    autoOptimiseStore = mkEnableOption "nix store automatic optimisation";
  };

  imports = [
    ./nh.nix
    ./substituters.nix
  ];

  config = let
    selfConfig = config.zeide.nix;
  in {
    nixpkgs = {
      inherit system;
      config.allowUnfree = true;
      overlays = [inputs.nix-vscode-extensions.overlays.default];
    };

    nix = {
      package =
        if selfConfig.useLix
        then pkgs.lix
        else pkgs.nix;

      settings = {
        auto-optimise-store = selfConfig.autoOptimiseStore;
        builders-use-substitutes = true;
        experimental-features = ["nix-command" "flakes"];

        trusted-users = ["root" "@wheel"];
      };
    };
  };
}
