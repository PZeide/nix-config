{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.gaming.lunar-client = with lib; {
    enable = mkEnableOption "lunar-client minecraft client";
  };

  config = let
    cfg = config.zeide.programs.gaming.lunar-client;
  in
    lib.mkIf cfg.enable {
      home.packages = [pkgs.lunar-client];
    };
}
