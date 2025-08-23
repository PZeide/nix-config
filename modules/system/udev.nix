{
  config,
  lib,
  ...
}: {
  options.zeide.udev = with lib; {
    keychron = mkEnableOption "rules for keychron keyboards";
    lamzu = mkEnableOption "rules for lamza mouse";
  };

  config = let
    selfConfig = config.zeide.udev;

    keychronRules = ''
      # Allow all devices with idVendor=3434 (which is the case for Keychron Q1 HE)
      SUBSYSTEM=="usb", ATTR{idVendor}=="3434", GROUP="users", MODE="0660"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", GROUP="users", MODE="0660"
    '';

    lamzuRules = ''
      # Allow all devices with idVendor=373e (which is the case for Lamzu Maya X 8K + Dongle)
      SUBSYSTEM=="usb", ATTRS{idVendor}=="373e", GROUP="users", MODE="0660"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373e", GROUP="users", MODE="0660"
    '';
  in {
    services.udev.extraRules = lib.concatStringsSep "\n" (
      lib.optional selfConfig.keychron keychronRules
      ++ lib.optional selfConfig.lamzu lamzuRules
    );
  };
}
