{
  config,
  lib,
  ...
}: {
  options.zeide.programs.starship = with lib; {
    enable = mkEnableOption "starship crosshell prompt";
  };

  imports = [./icons.nix];

  config = let
    selfConfig = config.zeide.programs.starship;
  in
    lib.mkIf selfConfig.enable {
      programs.starship = {
        enable = true;

        settings = {
          add_newline = true;

          character = {
            success_symbol = "[❯](bold green)";
            error_symbol = "[❯](bold red)";
            vicmd_symbol = "[❯](bold yellow)";
          };

          directory = {
            truncation_length = 2;
          };

          git_status = {
            conflicted = "=";
            up_to_date = "";
            untracked = "?\${count}";
            stashed = "\\$";
            modified = "!\${count}";
            staged = "+";
            renamed = "»";
            deleted = "✕";
            ahead = "⇡\${count}";
            diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
            behind = "⇣\${count}";
          };
        };
      };

      stylix.targets.starship.enable = true;
    };
}
