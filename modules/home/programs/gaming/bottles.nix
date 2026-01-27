{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.gaming.bottles = with lib; {
    enable = mkEnableOption "bottles manange non-steam games";
  };

  config = let
    cfg = config.zeide.programs.gaming.bottles;
  in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [bottles];
    };
}
