{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.gaming.wine-utils = with lib; {
    enable = mkEnableOption "wine utils (bottles and protonplus)";
  };

  config = let
    cfg = config.zeide.programs.gaming.wine-utils;
  in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [bottles protonplus];
    };
}
