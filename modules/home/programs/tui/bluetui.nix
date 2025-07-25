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
    selfConfig = config.zeide.programs.tui.bluetui;
  in
    lib.mkIf selfConfig.enable {
      home.packages = [pkgs.bluetui];
    };
}
