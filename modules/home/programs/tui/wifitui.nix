{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.tui.wifitui = with lib; {
    enable = mkEnableOption "wifitui (wifi manager)";
  };

  config = let
    cfg = config.zeide.programs.tui.wifitui;
  in
    lib.mkIf cfg.enable {
      home.packages = [pkgs.wifitui];
    };
}
