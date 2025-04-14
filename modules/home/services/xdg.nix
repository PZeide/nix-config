{
  asset,
  config,
  lib,
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
    selfConfig = config.zeide.services.xdg;

    mimeMap = builtins.fromJSON (builtins.readFile (asset "xdg/mime-map.json"));

    associations = with lib;
      listToAttrs (
        flatten (
          mapAttrsToList (
            key: map (type: attrsets.nameValuePair type selfConfig.defaultApps."${key}")
          )
          mimeMap
        )
      );
  in {
    xdg = {
      userDirs = lib.mkIf selfConfig.enableUserDirs {
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
