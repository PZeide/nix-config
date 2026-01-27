{
  config,
  lib,
  pkgs,
  ...
}: let
  fontType = lib.types.submodule {
    options = {
      package = lib.mkOption {
        description = "Package providing the font.";
        type = lib.types.package;
      };

      name = lib.mkOption {
        description = "Name of the font within the package.";
        type = lib.types.str;
      };
    };
  };
in {
  options.zeide.graphical.fonts = with lib; {
    enable = mkEnableOption "system-wide font config";

    serif = mkOption {
      description = "Serif font to use throughout the system.";
      type = fontType;
      default = {
        package = pkgs.crimson;
        name = "Crimson Text";
      };
    };

    sansSerif = mkOption {
      description = "Sans-serif font to use throughout the system.";
      type = fontType;
      default = {
        package = pkgs.vegur;
        name = "Vegur";
      };
    };

    monospace = mkOption {
      description = "Monospace font to use throughout the system.";
      type = fontType;
      default = {
        package = pkgs.iosevka;
        name = "Iosevka";
      };
    };

    emoji = mkOption {
      description = "Emoji font to use throughout the system.";
      type = fontType;
      default = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    extraFonts = mkOption {
      description = "Extra fonts to install for the system.";
      type = with types; listOf package;
      default = with pkgs; [
        # Various useful fonts
        noto-fonts
        noto-fonts-cjk-sans
        roboto

        # Nerd fonts symbols
        nerd-fonts.symbols-only
      ];
    };
  };

  config = let
    cfg = config.zeide.graphical.fonts;
  in
    lib.mkIf cfg.enable {
      fonts = {
        enableDefaultPackages = false;

        packages =
          [
            cfg.serif.package
            cfg.sansSerif.package
            cfg.monospace.package
            cfg.emoji.package
          ]
          ++ cfg.extraFonts;

        fontconfig = {
          enable = true;
          useEmbeddedBitmaps = true;

          # DejaVu Sans comes by default with fontconfig
          # DejaVu Sans is interfering with a LOT of fonts including Nerd Fonts
          localConf = ''
            <?xml version="1.0"?>
            <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
            <fontconfig>
              <selectfont>
                <rejectfont>
                  <pattern>
                    <patelt name="family">
                      <string>DejaVu Sans</string>
                    </patelt>
                  </pattern>
                </rejectfont>
              </selectfont>
            </fontconfig>
          '';

          defaultFonts = {
            serif = [cfg.serif.name];
            sansSerif = [cfg.sansSerif.name];
            monospace = [cfg.monospace.name];
            emoji = [cfg.emoji.name];
          };
        };
      };
    };
}
