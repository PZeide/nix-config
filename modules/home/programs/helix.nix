{
  config,
  lib,
  ...
}: {
  options.zeide.programs.helix = with lib; {
    enable = mkEnableOption "helix terminal editor";
  };

  config = let
    selfConfig = config.zeide.programs.helix;
  in
    lib.mkIf selfConfig.enable {
      programs.helix = {
        enable = true;
        defaultEditor = true;

        settings = {
          editor = {
            mouse = false;
            middle-click-paste = false;
            line-number = "relative";
            color-modes = true;

            lsp = {
              enable = true;
              display-inlay-hints = true;
            };

            cursor-shape = {
              normal = "block";
              insert = "bar";
              select = "block";
            };

            indent-guides = {
              render = true;
              character = "▏";
              skip-levels = 1;
            };
          };
        };
      };

      stylix.targets.helix = {
        enable = true;
        transparent = lib.mkForce true;
      };
    };
}
