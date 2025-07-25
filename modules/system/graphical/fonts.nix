{
  system,
  config,
  lib,
  pkgs,
  inputs,
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

    disableProblematicDefault = mkOption {
      description = ''
        Whether to disable the default DejaVu font.
        This font can cause various issues with emojis or nerd fonts symbols.
      '';
      type = types.bool;
      default = true;
    };

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
        package = pkgs.jost;
        name = "Jost";
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
        package = pkgs.noto-fonts-emoji;
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
    selfConfig = config.zeide.graphical.fonts;
  in
    lib.mkIf selfConfig.enable {
      fonts = {
        enableDefaultPackages = false;

        packages =
          [
            selfConfig.serif.package
            selfConfig.sansSerif.package
            selfConfig.monospace.package
            selfConfig.emoji.package
          ]
          ++ selfConfig.extraFonts;

        fontconfig = {
          enable = true;
          useEmbeddedBitmaps = true;

          /*
            localConf = lib.mkIf selfConfig.disableProblematicDefault ''
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
          */

          defaultFonts = {
            serif = [selfConfig.serif.name];
            sansSerif = [selfConfig.sansSerif.name];
            monospace = [selfConfig.monospace.name];
            emoji = [selfConfig.emoji.name];
          };
        };
      };
    };
}
