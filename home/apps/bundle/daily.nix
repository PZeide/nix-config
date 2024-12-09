{ pkgs, ... }:

{
  home.packages = with pkgs; [
    networkmanagerapplet
    mission-center
    seahorse

    vesktop
  ];
}
