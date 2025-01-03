{ pkgs, ... }:

let
  waydroidConfig = pkgs.writeText "waydroid.cfg" ''
    persist.waydroid.multi_windows=true
    sys.use_memfd=true
  '';
in
{
  virtualisation.waydroid.enable = true;

  environment.etc."waydroid.cfg".source = waydroidConfig;
  environment.systemPackages = [ pkgs.waydroid-helper ];
}
