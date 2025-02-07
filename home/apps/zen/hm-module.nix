# From: https://github.com/Faupi/nixos-configs/blob/master/home-manager/modules/zen-browser.nix
{
  config,
  lib,
  inputs,
  system,
  ...
}: let
  configPath = ".zen";
  modulePath = ["programs" "zen-browser"];
  cfg = lib.getAttrFromPath modulePath config;

  mkFirefoxModule = import "${inputs.home-manager.outPath}/modules/programs/firefox/mkFirefoxModule.nix";

  # Dookie way of patching the profiles.ini file
  # Basically Zen gets upset it can't write the default avatar path into the profile INI, so it thinks it can't load it and shits the bed
  profiles =
    lib.flip lib.mapAttrs' cfg.profiles
    (_: profile:
      lib.nameValuePair "Profile${toString profile.id}" {
        Name = profile.name;
        Path = profile.path;
        IsRelative = 1;
        Default =
          if profile.isDefault
          then 1
          else 0;
        ZenAvatarPath = "chrome://browser/content/zen-avatars/avatar-17.svg"; # Default path for now
      })
    // {
      General =
        {
          StartWithLastProfile = 1;
        }
        // lib.optionalAttrs (cfg.profileVersion != null) {
          Version = cfg.profileVersion;
        };
    };

  profilesIni = lib.generators.toINI {} profiles;
in {
  imports = [
    (mkFirefoxModule {
      inherit modulePath;
      name = "ZenBrowser";
      wrappedPackageName = "zen";
      unwrappedPackageName = null;
      platforms.linux.configPath = configPath;
    })
  ];

  config = {
    programs.zen-browser.package = inputs.zen-browser.packages.${system}.default;

    # Workaround for profiles INI making profiles unloadable
    home.file."${cfg.configPath}/profiles.ini" = lib.mkForce (lib.mkIf (cfg.profiles != {}) {text = profilesIni;});
  };
}
