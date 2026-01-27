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
    cfg = config.zeide.network;
  in
    lib.mkIf cfg.enable {
      networking = {
        nameservers = lib.optionals cfg.enableCloudflareDns [
          "1.1.1.1#one.one.one.one"
          "1.0.0.1#one.one.one.one"
        ];

        networkmanager = {
          enable = true;
          dns = "systemd-resolved";
        };

        firewall = {
          enable = cfg.enableFirewall;
          # Required by some VPN services
          checkReversePath = "loose";
        };
      };

      services.resolved = {
        enable = true;

        settings.Resolve = {
          Domains = ["~."];

          DNSOverTLS =
            if cfg.enableCloudflareDns
            then "true"
            else "opportunistic";
        };
      };

      users.users.${config.zeide.user} = {
        extraGroups = ["networkmanager"];
      };
    };
}
