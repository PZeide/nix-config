{
  config,
  osConfig,
  lib,
  ...
}: {
  options.zeide.services.keyring = with lib; {
    enable = mkEnableOption "gnome-keyring user integration (requires system gnome-keyring)";
  };

  config = let
    cfg = config.zeide.services.keyring;
  in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = osConfig.zeide.services.keyring.enable;
          message = "osConfig.zeide.services.keyring.enable is required to enable user integration.";
        }
      ];

      services.gnome-keyring = {
        enable = true;
        components = [
          "pkcs11"
          "secrets"
          "ssh"
        ];
      };
    };
}
