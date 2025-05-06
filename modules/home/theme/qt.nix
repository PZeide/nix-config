{
  config,
  lib,
  ...
}: {
  options.zeide.theme.qt = with lib; {
    enable = mkEnableOption "qt theming support";
  };

  config = let
    selfConfig = config.zeide.theme.qt;
  in
    lib.mkIf selfConfig.enable {
      # Default platform (kvantum) looks really ugly
      qt.platformTheme.name =
        if config.stylix.polarity == "dark"
        then "adwaita-dark"
        else "adwaita";
    };
}
