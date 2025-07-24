{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}: let
  tomlFormat = pkgs.formats.toml {};
in {
  options.zeide.programs.tui.nyaa = with lib; {
    enable = mkEnableOption "nyaa (nyaa.si browser)";
    downloadDir = mkOption {
      type = types.path;
      default = "/var/lib/transmission/Downloads";
      description = ''
        The directory in which animes will be downloaded to.
      '';
    };
  };

  config = let
    selfConfig = config.zeide.programs.tui.nyaa;
  in
    lib.mkIf selfConfig.enable {
      assertions = [
        {
          assertion = osConfig.zeide.services.transmission.enable;
          message = "osConfig.zeide.services.transmission.enable is required to enable nyaa.";
        }
      ];

      home.packages = [pkgs.nyaa];

      xdg.configFile."nyaa/config.toml".source = tomlFormat.generate "config.toml" {
        theme = "Default";
        default_source = "Nyaa";
        download_client = "Transmission";

        client.transmission = {
          base_url = "http://localhost:9091/transmission/rpc";
          download_dir = selfConfig.downloadDir;
          labels = ["Anime"];
        };
      };
    };
}
