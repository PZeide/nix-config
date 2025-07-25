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
    selfConfig = config.zeide.programs.gaming.lunar-client;
  in
    lib.mkIf selfConfig.enable {
      home.packages = [pkgs.lunar-client];
    };
}
