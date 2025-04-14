{
  config,
  lib,
  pkgs,
  ...
}: let
  tomlFormat = pkgs.formats.toml {};
in {
  options.zeide.programs.helix = with lib; {
    enable = mkEnableOption "helix terminal editor";

    theme = mkOption {
      type = types.attrsOf tomlFormat.type;
      default = {
        inherits = "default";
      };
      description = ''
        Theme configuration to use.
      '';
    };
  };

  config = let
    selfConfig = config.zeide.programs.helix;
    themeName = "nix-zeide";
  in
    lib.mkIf selfConfig.enable {
      programs.helix = {
        enable = true;
        defaultEditor = true;

        settings = {
          theme = themeName;

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

        themes = {
          "${themeName}" = selfConfig.theme;
        };
      };
    };
}
