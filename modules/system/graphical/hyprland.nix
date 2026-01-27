{
  system,
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.zeide.graphical.hyprland = with lib; {
    enable = mkEnableOption "hyprland system support (required for home module)";
  };

  config = let
    cfg = config.zeide.graphical.hyprland;
  in
    lib.mkIf cfg.enable {
      programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${system}.hyprland;
        portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;

        # withUWSM is broken: https://github.com/hyprwm/Hyprland/discussions/12661
        withUWSM = false;
      };

      environment.systemPackages = [pkgs.uwsm];
      systemd.packages = [pkgs.uwsm];
      environment.pathsToLink = ["/share/uwsm"];
    };
}
