{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.theme.cursor = with lib; {
    package = mkOption {
      type = types.package;
      default = pkgs.bibata-cursors;
      description = "Package providing the cursor.";
    };

    name = mkOption {
      type = types.str;
      default = "Bibata-Modern-Classic";
      description = "Name of the cursor within the package.";
    };

    size = mkOption {
      type = types.int;
      default = 24;
      description = "Size of the cursor.";
    };
  };

  config = let
    selfConfig = config.zeide.theme.cursor;
  in {
    home.pointerCursor = {
      inherit (selfConfig) package name size;
      x11.enable = true;
      gtk.enable = true;
      hyprcursor.enable = true;
    };
  };
}
