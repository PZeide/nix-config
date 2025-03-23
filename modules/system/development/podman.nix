{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.development.podman = with lib; {
    enable = mkEnableOption "podman support";
    enableAutoPrune = mkEnableOption "podman weekly pruning";
  };

  config = let
    selfConfig = config.zeide.development.podman;
  in
    lib.mkIf selfConfig.enable {
      virtualisation = {
        containers.enable = true;

        podman = {
          enable = true;
          defaultNetwork.settings.dns_enabled = true;

          autoPrune = lib.mkIf selfConfig.enableAutoPrune {
            enable = true;
            flags = ["--all"];
            dates = "weekly";
          };
        };
      };

      environment.systemPackages = with pkgs; [podman-compose];
    };
}
