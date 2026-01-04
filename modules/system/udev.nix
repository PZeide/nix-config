{
  config,
  lib,
  ...
}: {
  options.zeide.udev = with lib; {
    keychron = mkEnableOption "rules for keychron keyboards";
    lamzu = mkEnableOption "rules for lamza mouse";
    heightbitdo = mkEnableOption "rules for 8bitdo controller in DInput mode";
  };

  config = let
    selfConfig = config.zeide.udev;

    keychronRules = ''
      # Allow all devices with idVendor=3434 (which is the case for Keychron Q1 HE)
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", TAG+="uaccess"
    '';

    lamzuRules = ''
      # Allow all devices with idVendor=373e (which is the case for Lamzu Maya X 8K + Dongle)
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373e", TAG+="uaccess"
    '';

    heightbitdoRules = ''
      # Allow all devices with idVendor=2dc8 (which is the case for 8BitDo Ultimate Wireless 2 Controller)
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2dc8", TAG+="uaccess"
    '';
  in {
    services.udev.extraRules = lib.concatStringsSep "\n" (
      lib.optional selfConfig.keychron keychronRules
      ++ lib.optional selfConfig.lamzu lamzuRules
      ++ lib.optional selfConfig.heightbitdo heightbitdoRules
    );
  };
}
