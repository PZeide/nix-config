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
    cfg = config.zeide.development.podman;
  in
    lib.mkIf cfg.enable {
      virtualisation = {
        containers.enable = true;

        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;

          autoPrune = lib.mkIf cfg.enableAutoPrune {
            enable = true;
            flags = ["--all"];
            dates = "weekly";
          };
        };
      };

      environment = {
        systemPackages = with pkgs; [podman-compose];
        shellAliases = {
          docker-compose = "podman-compose";
        };
      };
    };
}
