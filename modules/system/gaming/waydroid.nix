{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.gaming.waydroid = with lib; {
    enable = mkEnableOption "waydroid (android emulator)";
  };

  config = let
    selfConfig = config.zeide.gaming.waydroid;

    waydroidConfig = pkgs.writeText "waydroid.cfg" ''
      sys.use_memfd=true
    '';
  in
    lib.mkIf selfConfig.enable {
      virtualisation.waydroid.enable = true;

      environment.etc."waydroid.cfg".source = waydroidConfig;
      environment.systemPackages = with pkgs; [
        waydroid-helper
        wl-clipboard
      ];
    };
}
