{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.services.anime = with lib; {
    enable = mkEnableOption "anime auto-download and tools to auto-sync";
    symlinkAnimes = mkEnableOption "symlink torrent download folder to $HOME/Animes directory";

    anilistUsername = mkOption {
      type = types.str;
      default = "Zeide";
      description = ''
        Username of the Anilist account to use for anime auto-download.
      '';
    };

    downloadQuality = mkOption {
      type = types.str;
      default = "1080p+ !cam";
      description = ''
        Quality of the anime to download.
      '';
    };
  };

  config = let
    selfConfig = config.zeide.services.anime;
  in
    lib.mkIf selfConfig.enable {
      assertions = [
        {
          assertion = config.zeide.services.transmission.enable;
          message = "config.zeide.services.transmission.enable; is required to enable anime auto-download in home.";
        }
      ];

      environment.systemPackages = [pkgs.trackma-qt];

      services.flexget = {
        enable = true;
        user = "transmission";
        homeDir = "/var/lib/transmission";

        config = ''
          tasks:
            anime:
              rss: "https://subsplease.org/rss/?t&r=1080"

              transmission:
                host: "localhost"
                port: 9091

              configure_series:
                settings:
                  quality: "${selfConfig.downloadQuality}"
                from:
                  anilist:
                    username: "${selfConfig.anilistUsername}"
                    status:
                      - current
                      - repeating
                    release_status:
                      - releasing

              set:
                path: "/var/lib/transmission/Animes/{{series_name}}"
        '';
      };

      systemd.tmpfiles.rules =
        [
          "d /var/lib/transmission/Animes 0770 transmission transmission -"
        ]
        ++ lib.optional selfConfig.symlinkAnimes "L+ /home/${config.zeide.user}/Animes - - - - /var/lib/transmission/Animes";
    };
}
