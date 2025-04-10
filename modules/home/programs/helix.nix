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
        };

        themes = {
          "${themeName}" = selfConfig.theme;
        };
      };
    };
}
