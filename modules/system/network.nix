{
  config,
  lib,
  ...
}: {
  options.zeide.network = with lib; {
    enable = mkEnableOption "network config";
    enableWireless = mkEnableOption "wireless (using wpa_supplicant)";
    enableCloudflareDns = mkEnableOption "Cloudflare DNS with DoT";
    enableFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable default firewall with strict rules.
        By default, no incoming connections are accepted.
      '';
    };
  };

  config = let
    selfConfig = config.zeide.network;
  in
    lib.mkIf selfConfig.enable {
      networking = {
        nameservers = lib.optionals selfConfig.enableCloudflareDns [
          "1.1.1.1#one.one.one.one"
          "1.0.0.1#one.one.one.one"
        ];

        networkmanager = {
          enable = true;
          dns = "systemd-resolved";
        };

        firewall = {
          enable = selfConfig.enableFirewall;
          # Required by some VPN services
          checkReversePath = "loose";
        };
      };

      services.resolved = {
        enable = true;
        domains = ["~."];

        dnsovertls =
          if selfConfig.enableCloudflareDns
          then "true"
          else "opportunistic";
      };

      users.users.${config.zeide.user} = {
        extraGroups = ["networkmanager"];
      };
    };
}
