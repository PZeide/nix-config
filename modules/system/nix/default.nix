{
  system,
  config,
  lib,
  inputs,
  ...
}: {
  options.zeide.nix = with lib; {
    enableCudaSupport = mkEnableOption "enable cuda support";
    enableRocmSupport = mkEnableOption "enable rocm support";
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

      config = {
        allowUnfree = true;
        cudaSupport = selfConfig.enableCudaSupport;
        rocmSupport = selfConfig.enableRocmSupport;
      };

      overlays = [inputs.nix-vscode-extensions.overlays.default];
    };

    nix = {
      settings = {
        auto-optimise-store = selfConfig.autoOptimiseStore;
        builders-use-substitutes = true;
        experimental-features = ["nix-command" "flakes" "pipe-operators"];

        trusted-users = ["root" "@wheel"];
      };
    };
  };
}
