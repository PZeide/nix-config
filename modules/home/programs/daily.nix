{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.daily = with lib; {
    seahorse.enable = mkEnableOption "seahorse (secrets utility)";
    mission-center.enable = mkEnableOption "mission-center (task manager)";
    overskride.enable = mkEnableOption "overskride (bluetooth settings)";
    nm-applet.enable = mkEnableOption "nm-applet (network settings)";
    disk-utility.enable = mkEnableOption "disk-utility";
    loupe.enable = mkEnableOption "loupe (image viewer)";
    file-roller.enable = mkEnableOption "file-roller (archive manager)";
    papers.enable = mkEnableOption "papers (pdf viewer)";
    pods.enable = mkEnableOption "pods (podman manager)";
  };

  config = let
    selfConfig = config.zeide.programs.daily;
  in
    lib.mkMerge [
      (lib.mkIf selfConfig.seahorse.enable {
        home.packages = [pkgs.seahorse];
      })
      (lib.mkIf selfConfig.mission-center.enable {
        home.packages = [pkgs.mission-center];
      })
      (lib.mkIf selfConfig.overskride.enable {
        home.packages = [pkgs.overskride];
      })
      (lib.mkIf selfConfig.nm-applet.enable {
        home.packages = [pkgs.networkmanagerapplet];
      })
      (lib.mkIf selfConfig.disk-utility.enable {
        home.packages = [pkgs.gnome-disk-utility];
      })
      (lib.mkIf selfConfig.loupe.enable {
        home.packages = [pkgs.loupe];
      })
      (lib.mkIf selfConfig.file-roller.enable {
        home.packages = [pkgs.file-roller];
      })
      (lib.mkIf selfConfig.papers.enable {
        home.packages = [pkgs.papers];
      })
      (lib.mkIf selfConfig.pods.enable {
        home.packages = [pkgs.pods];
      })
    ];
}
