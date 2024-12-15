{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Terminal tools
    playerctl
    brightnessctl

    # System maintenance
    networkmanagerapplet
    mission-center
    seahorse
    overskride

    # Utilities
    gnome-calculator
    gnome-disk-utility
    loupe

    # Other
    vesktop
  ];

  programs.obs-studio.enable = true;
}
