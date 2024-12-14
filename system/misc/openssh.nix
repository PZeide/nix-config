{
  config,
  lib,
  ...
}:

let
  cfg = config.main.openssh;
in
{
  options.main.openssh = with lib; {
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
