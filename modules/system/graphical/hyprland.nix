{
  system,
  config,
  lib,
  inputs,
  ...
}: {
  options.zeide.graphical.hyprland = with lib; {
    enable = mkEnableOption "hyprland system support (required for home module)";
  };

  config = let
    selfConfig = config.zeide.graphical.hyprland;
  in
    lib.mkIf selfConfig.enable {
      programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${system}.hyprland;
        portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
        withUWSM = true;
      };
    };
}
