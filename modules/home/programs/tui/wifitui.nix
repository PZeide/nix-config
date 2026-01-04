{
  config,
  lib,
  inputs,
  system,
  ...
}: {
  options.zeide.programs.tui.wifitui = with lib; {
    enable = mkEnableOption "wifitui (wifi manager)";
  };

  config = let
    selfConfig = config.zeide.programs.tui.wifitui;
  in
    lib.mkIf selfConfig.enable {
      home.packages = [inputs.wifitui.packages.${system}.default];
    };
}
