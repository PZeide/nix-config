{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.tui.bluetui = with lib; {
    enable = mkEnableOption "bluetui (bluetooth manager)";
  };

  config = let
    cfg = config.zeide.programs.tui.bluetui;
  in
    lib.mkIf cfg.enable {
      home.packages = [pkgs.bluetui];
    };
}
