{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.home.core;
in {
  imports = [inputs.stylix.homeManagerModules.stylix];

  options.home.core = with lib; {
    wallpaper = mkOption {
      type = with types; coercedTo package toString path;
      description = ''
        Wallpaper image used to generate color palette and theming.
      '';
    };

    polarity = mkOption {
      type = types.enum [
        "either"
        "light"
        "dark"
      ];
      default = "either";
      description = ''
        Force the use of light or dark mode.
        "either" will use the best.
      '';
    };
  };

  config = {
    stylix = {
      enable = true;
      autoEnable = false;

      image = cfg.wallpaper;
      polarity = cfg.polarity;
    };
  };
}
