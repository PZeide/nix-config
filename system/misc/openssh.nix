{
  config,
  lib,
  ...
}: let
  cfg = config.system.openssh;
in {
  options.system.openssh = with lib; {
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Should firewall be opened to allow incoming connecitons.
      '';
    };
  };

  config = {
    services.openssh = {
      enable = true;
      openFirewall = cfg.openFirewall;
    };
  };
}
