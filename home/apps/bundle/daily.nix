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

    vesktop
  ];
}
