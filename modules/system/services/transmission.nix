{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.services.transmission = with lib; {
    enable = mkEnableOption "transmission BitTorrent client daemon";
    symlinkDownloads = mkEnableOption "symlink torrent download folder to $HOME/Torrents directory";
    notifyOnDone = mkEnableOption "notify when a torrent has finished downloading";
  };

  config = let
    selfConfig = config.zeide.services.transmission;
  in
    lib.mkIf selfConfig.enable {
      services.transmission = {
        enable = true;
        package = pkgs.transmission_4;
        downloadDirPermissions = "770";
        settings = {
          script-torrent-done-enabled = selfConfig.notifyOnDone;
          script-torrent-done-filename = pkgs.writeShellScript "transmission-done" ''
            TR_TORRENT_DIR=''${TR_TORRENT_DIR:-$1}
            TR_TORRENT_NAME=''${TR_TORRENT_NAME:-$2}

            ${pkgs.libnotify}/bin/notify-send \
              --urgency=normal \
              --icon=transmission \
              --app-name="Transmission" \
              --action="open_dir=Open Folder" \
              "Torrent Download Complete" \
              "Torrent $TORRENT_NAME has finished downloading."
          '';
        };
      };

      systemd.tmpfiles.rules = lib.mkIf selfConfig.symlinkDownloads [
        "L+ /home/${config.zeide.user}/Torrents - - - - /var/lib/transmission/Downloads"
      ];

      users.users.${config.zeide.user} = {
        extraGroups = ["transmission"];
      };
    };
}
