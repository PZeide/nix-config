{
  lib,
  config,
  inputs,
  system,
  ...
}: {
  options.zeide.graphical.hyprland.companions.hyprpicker = with lib; {
    enable = mkEnableOption "hyprpicker color picker utility";
  };

  config = let
    selfConfig = config.zeide.graphical.hyprland.companions.hyprpicker;
  in
    lib.mkIf selfConfig.enable {
      home.packages = [inputs.hyprpicker.packages.${system}.default];
    };
}
