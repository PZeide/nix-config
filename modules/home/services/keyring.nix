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
          assertion = osConfig.zeide.services.gnome.enableKeyring;
          message = "osConfig.zeide.services.gnome.enableKeyring is required to enable user integration.";
        }
      ];

      home.sessionVariables = {
        SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
      };

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
