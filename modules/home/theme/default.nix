{
  asset,
  config,
  osConfig,
  lib,
  inputs,
  pkgs,
  system,
  ...
}: {
  options.zeide.theme = with lib; {
    face = mkOption {
      type = with types; coercedTo path (src: "${src}") pathInStore;
      default = asset "faces/laevatain.png";
      description = ''
        User face image.
      '';
    };

    wallpaper = mkOption {
      type = with types; coercedTo path (src: "${src}") pathInStore;
      default = asset "wallpapers/laevatain.jpg";
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
        "vibrant"
      ];
      default = "content";
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

    palette = mkOption {
      type = types.attrsOf (types.nullOr (types.attrsOf types.str));
      readOnly = true;
      description = ''
        Generated Base16, Base24, and semantic (Material You) color representations.
        Colors are hexadecimal strings without a leading #.
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
    cfg = config.zeide.theme;
    spg = inputs.stylix-palette-generators.lib.${system};
  in {
    home.file.".face".source = cfg.face;

    zeide.theme.palette = spg.mkExtraRepresentations {
      image = config.stylix.image;
      polarity = config.stylix.polarity;

      generators.semantic = spg.generators.semantic.matugen {
        scheme = cfg.scheme;
        contrast = cfg.contrast;
        lightnessDark = -0.02;
        lightnessLight = 0.0;
      };

      mappingFunction = lib.flip lib.pipe [
        spg.mappings.semantic2base16
        spg.mappings.base162base24
      ];
    };

    stylix = {
      enable = true;
      autoEnable = false;
      enableReleaseChecks = false;

      image = cfg.wallpaper;
      polarity = cfg.polarity;

      base16Scheme = spg.mkScheme {
        manual.base16 = cfg.palette.base16;
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
