{
  config,
  lib,
  ...
}: {
  options.zeide.programs.starship = with lib; {
    enable = mkEnableOption "starship crosshell prompt";
  };

  config = let
    cfg = config.zeide.programs.starship;
  in
    lib.mkIf cfg.enable {
      programs.starship = {
        enable = true;

        settings = {
          add_newline = true;
          command_timeout = 200;
          format = "[$directory$git_branch$git_status]($style)$character";

          character = {
            error_symbol = "[✗](bold cyan)";
            success_symbol = "[❯](bold cyan)";
          };

          directory = {
            truncation_length = 2;
            truncation_symbol = "…/";
            repo_root_format = "[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) ";
          };

          git_branch = {
            format = "[$branch]($style) ";
          };

          git_status = {
            format = "[$all_status]($style)";
            ahead = "⇡\${count} ";
            diverged = "⇕⇡\${ahead_count}⇣\${behind_count} ";
            behind = "⇣\${count} ";
            conflicted = " ";
            untracked = "? ";
            modified = "!\${count} ";
            up_to_date = "";
            stashed = "";
            staged = "";
            renamed = "";
            deleted = "";
          };
        };
      };

      stylix.targets.starship.enable = true;
    };
}
