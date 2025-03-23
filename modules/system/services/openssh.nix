{
  config,
  lib,
  ...
}: {
  options.zeide.services.openssh = with lib; {
    enable = mkEnableOption "openssh service";
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Should firewall be opened to allow incoming connections.
      '';
    };
  };

  config = let
    selfConfig = config.zeide.services.openssh;
  in
    lib.mkIf selfConfig.enable {
      services.openssh = {
        enable = true;
        openFirewall = selfConfig.openFirewall;
      };
    };
}
