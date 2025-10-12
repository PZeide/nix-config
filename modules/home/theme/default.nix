{
  asset,
  config,
  osConfig,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.zeide.theme = with lib; {
    wallpaper = mkOption {
      type = with types; coercedTo package toString path;
      default = asset "wallpapers/rem.jpg";
      description = ''
        Wallpaper image (will drive the generation of the color palette).
      '';
    };

    polarity = mkOption {
      type = types.enum [
        "light"
        "dark"
      ];
      default = "dark";
      description = ''
        Use of light or dark mode.
      '';
    };

    scheme = lib.mkOption {
      type = lib.types.enum [
        "content"
        "expressive"
        "fidelity"
        "fruit-salad"
        "monochrome"
        "neutral"
        "rainbow"
        "tonal-spot"
      ];
      default = "tonal-spot";
      description = ''
        Color scheme type used to generate the colors from the wallpaper.
      '';
    };

    contrast = lib.mkOption {
      type = lib.types.addCheck lib.types.float (x: x >= -1.0 && x <= 1.0);
      default = 0.0;
      description = ''
        Number from -1 (minimum contrast) to 1 (maximum contrast) used to generate colors.
      '';
    };
  };

  imports = [
    ./cursor.nix
    ./gtk.nix
    ./qt.nix

    inputs.stylix.homeModules.stylix
  ];

  config = let
    selfConfig = config.zeide.theme;
  in {
    stylix = {
      enable = true;
      autoEnable = false;

      image = selfConfig.wallpaper;

      colorGeneration = {
        polarity = selfConfig.polarity;
        scheme = selfConfig.scheme;
        contrast = selfConfig.contrast;
      };

      # If system-wide fonts config is enabled, use the fonts from there.
      fonts = lib.mkIf osConfig.zeide.graphical.fonts.enable {
        serif = osConfig.zeide.graphical.fonts.serif;
        sansSerif = osConfig.zeide.graphical.fonts.sansSerif;
        monospace = osConfig.zeide.graphical.fonts.monospace;
        emoji = osConfig.zeide.graphical.fonts.emoji;
      };

      icons = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        light = "Papirus-Light";
        dark = "Papirus-Dark";
      };
    };
  };
}
