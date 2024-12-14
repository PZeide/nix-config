{ lib, ... }:

{
  services.hyprpaper.enable = true;
  stylix.targets.hyprpaper.enable = true;

  systemd.user.services.hypridle.Unit.After = lib.mkForce [ "graphical-session.target" ];
}
