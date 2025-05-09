{
  config,
  lib,
  ...
}: {
  options.zeide.network = with lib; {
    enable = mkEnableOption "network config";
    enableQuad9Dns = mkEnableOption "quad9 DNS with DoT and DNSSEC";
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
        nameservers = lib.optionals selfConfig.enableQuad9Dns [
          "9.9.9.9#dns.quad9.net"
          "149.112.112.112#dns.quad9.net"
        ];

        networkmanager = {
          enable = true;
          wifi.powersave = true;
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
          if selfConfig.enableQuad9Dns
          then "true"
          else "opportunistic";
      };

      users.users.${config.zeide.user} = {
        extraGroups = ["networkmanager"];
      };
    };
}
