{
  asset,
  config,
  osConfig,
  lib,
  inputs,
  ...
}: {
  options.zeide.theme = with lib; {
    wallpaper = mkOption {
      type = with types; coercedTo package toString path;
      default = asset "wallpapers/rem.jpg";
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

  imports = [
    ./cursor.nix
    ./gtk.nix

    inputs.stylix.homeManagerModules.stylix
  ];

  config = let
    selfConfig = config.zeide.theme;
  in {
    stylix = {
      enable = true;
      autoEnable = false;

      image = selfConfig.wallpaper;
      polarity = selfConfig.polarity;

      # If system-wide fonts config is enabled, use the fonts from there.
      fonts = lib.mkIf osConfig.zeide.graphical.fonts.enable {
        serif = osConfig.zeide.graphical.fonts.serif;
        sansSerif = osConfig.zeide.graphical.fonts.sansSerif;
        monospace = osConfig.zeide.graphical.fonts.monospace;
        emoji = osConfig.zeide.graphical.fonts.emoji;
      };
    };
  };
}
