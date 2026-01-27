{
  asset,
  config,
  lib,
  pkgs,
  ...
}: let
  mkDefaultAppsOption' = appType:
    lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      description = ''
        Set the default applications for application type ${appType}.
      '';
    };
in {
  options.zeide.services.xdg = with lib; {
    enableUserDirs = mkEnableOption "xdg user directories";

    execTerminal = mkOption {
      type = with lib.types; nullOr str;
      default = null;
      description = ''
        Desktop file of the default terminal, not configuring this can cause issues in some apps.
      '';
    };

    defaultApps = {
      browser = mkDefaultAppsOption' "browser";
      text = mkDefaultAppsOption' "text";
      image = mkDefaultAppsOption' "image";
      audio = mkDefaultAppsOption' "audio";
      video = mkDefaultAppsOption' "video";
      directory = mkDefaultAppsOption' "directory";
      office = mkDefaultAppsOption' "office";
      pdf = mkDefaultAppsOption' "pdf";
      terminal = mkDefaultAppsOption' "terminal";
      archive = mkDefaultAppsOption' "archive";
      discord = mkDefaultAppsOption' "discord";
    };
  };

  config = let
    cfg = config.zeide.services.xdg;

    mimeMap = builtins.fromJSON (builtins.readFile (asset "xdg/mime-map.json"));

    associations = with lib;
      listToAttrs (
        flatten (
          mapAttrsToList (
            key: map (type: attrsets.nameValuePair type cfg.defaultApps."${key}")
          )
          mimeMap
        )
      );
  in {
    home.packages = lib.optional (cfg.execTerminal != null) pkgs.xdg-terminal-exec;

    xdg.configFile."xdg-terminals.list" = {
      enable = cfg.execTerminal != null;
      text = "${cfg.execTerminal}";
    };

    dconf.settings."org/gnome/desktop/applications/terminal".exec =
      lib.mkIf (cfg.execTerminal != null)
      (lib.getExe pkgs.xdg-terminal-exec);

    xdg = {
      userDirs = lib.mkIf cfg.enableUserDirs {
        enable = true;
        createDirectories = true;
      };

      mime.enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = associations;
      };
    };
  };
}
