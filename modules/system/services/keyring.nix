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
    cfg = config.zeide.services.keyring;
  in {
    services.gnome.gnome-keyring.enable = cfg.enable;
    security.pam.services = lib.genAttrs cfg.unlockServices (service: {
      name = service;
      enableGnomeKeyring = true;
    });
  };
}
