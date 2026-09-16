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
    cfg = config.zeide.services.openssh;
  in
    lib.mkIf cfg.enable {
      services.openssh = {
        enable = true;
        openFirewall = cfg.openFirewall;
      };
    };
}
