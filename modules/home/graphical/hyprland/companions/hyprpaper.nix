{
  lib,
  config,
  inputs,
  system,
  ...
}: {
  options.zeide.graphical.hyprland.companions.hyprpaper = with lib; {
    enable = mkEnableOption "hyprpaper wallpaper daemon";
  };

  config = let
    selfConfig = config.zeide.graphical.hyprland.companions.hyprpaper;
  in
    lib.mkIf selfConfig.enable {
      services.hyprpaper = {
        enable = true;
        package = inputs.hyprpaper.packages.${system}.default;
      };

      stylix.targets.hyprpaper.enable = true;
    };
}
