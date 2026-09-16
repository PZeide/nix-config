{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.services.ios = with lib; {
    enable = mkEnableOption "ios tethering";
  };

  config = let
    cfg = config.zeide.services.ios;
  in
    lib.mkIf cfg.enable {
      services.usbmuxd = {
        enable = true;
        package = pkgs.usbmuxd2;
      };

      environment.systemPackages = with pkgs; [libimobiledevice];
    };
}
