{ inputs, system, ... }:

{
  fonts = {
    enableDefaultPackages = false;
    enableGhostscriptFonts = false;
  };

  # Use home module for further configuration
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${system}".hyprland;
    portalPackage = inputs.hyprland.packages."${system}".xdg-desktop-portal-hyprland;
    withUWSM = true;
  };

  # TEMP
  environment.systemPackages = [
    inputs.zen-browser.packages."${system}".specific
  ];
}
