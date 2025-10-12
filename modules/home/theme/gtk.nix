{
  config,
  lib,
  ...
}: {
  options.zeide.theme.gtk = with lib; {
    enable = mkEnableOption "gtk theming support";
  };

  config = let
    selfConfig = config.zeide.theme.gtk;
  in
    lib.mkIf selfConfig.enable {
      gtk.enable = true;

      dconf.settings."org/gnome/desktop/interface" = let
        fontSize = toString config.stylix.fonts.sizes.applications;
        documentFontSize = toString (config.stylix.fonts.sizes.applications - 1);
      in {
        color-scheme =
          if config.stylix.colorGeneration.polarity == "dark"
          then "prefer-dark"
          else "default";

        font-name = "${config.stylix.fonts.sansSerif.name} ${fontSize}";
        document-font-name = "${config.stylix.fonts.serif.name}  ${documentFontSize}";
        monospace-font-name = "${config.stylix.fonts.monospace.name} ${fontSize}";
      };

      stylix.targets.gtk.enable = true;
    };
}
