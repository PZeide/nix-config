{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.zeide.gaming.optimizations = with lib; {
    enable = mkEnableOption "various system optimizations for gaming";
  };

  imports = [inputs.nix-gaming.nixosModules.platformOptimizations];

  config = let
    cfg = config.zeide.gaming.optimizations;
  in
    lib.mkIf cfg.enable {
      programs.steam.platformOptimizations.enable = true;

      boot.kernelModules = ["ntsync"];

      services.udev.packages = [
        (pkgs.writeTextFile {
          name = "ntsync-udev-rules";
          text = ''KERNEL=="ntsync", MODE="0660", TAG+="uaccess"'';
          destination = "/etc/udev/rules.d/70-ntsync.rules";
        })
      ];
    };
}
