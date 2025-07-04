{
  config,
  lib,
  inputs,
  ...
}: {
  options.zeide.gaming.optimizations = with lib; {
    enable = mkEnableOption "various system optimizations for gaming";
  };

  imports = with inputs.nix-gaming.nixosModules; [platformOptimizations ntsync];

  config = let
    selfConfig = config.zeide.gaming.optimizations;
  in
    lib.mkIf selfConfig.enable {
      programs = {
        steam.platformOptimizations.enable = true;
        wine.ntsync.enable = true;
      };
    };
}
