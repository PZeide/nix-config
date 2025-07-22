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
    selfConfig = config.zeide.services.keyring;
  in
    lib.mkIf selfConfig.enable {
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
