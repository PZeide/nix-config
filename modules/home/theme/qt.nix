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
      stylix.targets.qt = {
        enable = true;
        # Default platform (kvantum) looks really ugly
        platform = "gnome";
      };
    };
}
