{
  config,
  lib,
  pkgs,
  ...
}: let
  kvantumThemeType = lib.types.submodule {
    options = {
      package = lib.mkOption {
        type = lib.types.package;
        description = "The package of the Kvantum theme";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the Kvantum theme";
      };
    };
  };
in {
  options.zeide.theme.qt = with lib; {
    enable = mkEnableOption "qt theming support";
    kvantumTheme = mkOption {
      type = with types; nullOr kvantumThemeType;
      default = null;
      description = "Package providing the Kvantum theme.";
    };
  };

  config = let
    selfConfig = config.zeide.theme.qt;
  in
    lib.mkIf selfConfig.enable {
      qt = {
        enable = true;
        style.name = "kvantum";
        platformTheme.name = "qtct";
      };

      xdg.configFile = let
        icons =
          if (config.stylix.polarity == "dark")
          then config.stylix.icons.dark
          else config.stylix.icons.light;

        qtctConf = ''
          [Appearance]
          style=${config.qt.style.name}
          icon_theme=${icons}
        '';
      in
        lib.mkMerge [
          (lib.mkIf (selfConfig.kvantumTheme != null) {
            "Kvantum/kvantum.kvconfig".source =
              (pkgs.formats.ini {}).generate "kvantum.kvconfig"
              {
                General.theme = selfConfig.kvantumTheme.name;
              };

            "Kvantum/${selfConfig.kvantumTheme.name}".source = "${selfConfig.kvantumTheme.package}/share/Kvantum/${selfConfig.kvantumTheme.name}";
          })
          {
            "qt5ct/qt5ct.conf".text = qtctConf;
            "qt6ct/qt6ct.conf".text = qtctConf;
          }
        ];
    };
}
