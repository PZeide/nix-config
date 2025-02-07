{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mangohud
    bottles
  ];

  programs.steam.enable = true;
}
