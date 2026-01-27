{
  config,
  lib,
  ...
}: {
  options.zeide.programs.kitty = with lib; {
    enable = mkEnableOption "kitty terminal";
  };

  config = let
    cfg = config.zeide.programs.kitty;
  in
    lib.mkIf cfg.enable {
      programs.kitty = {
        enable = true;

        settings = {
          mouse_hide_wait = 0;
          detect_urls = true;
          show_hyperlink_targets = true;

          background_opacity = lib.mkForce 0.65;
          background_blur = 0;

          enable_audio_bell = false;

          remember_window_size = false;
          window_padding_width = 8;
          hide_window_decorations = true;
          confirm_os_window_close = 0;
          cursor_trail = 1;
        };
      };

      stylix.targets.kitty.enable = true;
    };
}
