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
    cfg = config.zeide.nix;
  in {
    nixpkgs = {
      inherit system;

      config = {
        allowUnfree = true;
        cudaSupport = cfg.enableCudaSupport;
        rocmSupport = cfg.enableRocmSupport;
      };

      overlays = [
        inputs.nix-webapps.overlays.lib
        inputs.nix-cachyos-kernel.overlays.pinned

        # Fix for gnome-keyring crashing
        # SEE: https://gitlab.gnome.org/GNOME/gnome-keyring/-/work_items/190
        (_: prev: {
          gnome-keyring = prev.gnome-keyring.overrideAttrs (old: {
            patches =
              (old.patches or [])
              ++ [
                ./patches/gnome-keyring-opensession-fix.patch
              ];
          });
        })
      ];
    };

    nix = {
      settings = {
        auto-optimise-store = cfg.autoOptimiseStore;
        builders-use-substitutes = true;
        experimental-features = ["nix-command" "flakes" "pipe-operators"];

        trusted-users = ["root" "@wheel"];
      };
    };
  };
}
