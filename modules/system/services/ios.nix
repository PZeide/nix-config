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
    selfConfig = config.zeide.services.ios;
  in
    lib.mkIf selfConfig.enable {
      services.usbmuxd = {
        enable = true;
        package = pkgs.usbmuxd2;
      };

      environment.systemPackages = with pkgs; [libimobiledevice];
    };
}
