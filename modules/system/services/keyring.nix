{
  config,
  lib,
  ...
}: {
  options.zeide.services.keyring = with lib; {
    enable = mkEnableOption "gnome keyring";
    unlockServices = mkOption {
      type = with types; listOf str;
      default = [];
      description = ''
        List of PAM services that will automatically unlock gnome keyring.
      '';
    };
  };

  config = let
    selfConfig = config.zeide.services.keyring;
  in {
    services.gnome.gnome-keyring.enable = selfConfig.enable;
    security.pam.services = lib.genAttrs selfConfig.unlockServices (service: {
      name = service;
      enableGnomeKeyring = true;
    });
  };
}
