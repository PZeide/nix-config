{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}: let
  tomlFormat = pkgs.formats.toml {};
in {
  options.zeide.programs.tui.rustmission = with lib; {
    enable = mkEnableOption "rustmission (transmission TUI)";
  };

  config = let
    selfConfig = config.zeide.programs.tui.rustmission;
  in
    lib.mkIf selfConfig.enable {
      assertions = [
        {
          assertion = osConfig.zeide.services.transmission.enable;
          message = "osConfig.zeide.services.transmission.enable is required to enable rustmission.";
        }
      ];

      home.packages = [pkgs.rustmission];

      xdg.configFile."rustmission/config.toml".source = tomlFormat.generate "config.toml" {
        beginner_mode = true;

        connection = {
          url = "http://localhost:9091/transmission/rpc";
          torrents_refresh = 1;
          stats_refresh = 1;
          free_space_refresh = 5;
        };

        torrents_tab = {
          headers = [
            "Name"
            "SizeWhenDone"
            "Progress"
            "Eta"
            "DownloadRate"
            "UploadRate"
          ];
        };
      };

      xdg.configFile."rustmission/categories.toml".source = tomlFormat.generate "categories.toml" {
        categories = [
          {
            name = "Anime";
            icon = "";
            color = "LightMagenta";
            default_dir = "/var/lib/transmission/Downloads";
          }
        ];
      };
    };
}
