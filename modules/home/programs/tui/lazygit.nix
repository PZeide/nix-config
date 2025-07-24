{
  config,
  lib,
  ...
}: {
  options.zeide.programs.tui.lazygit = with lib; {
    enable = mkEnableOption "lazygit (git helper)";
  };

  config = let
    selfConfig = config.zeide.programs.tui.lazygit;
  in
    lib.mkIf selfConfig.enable {
      programs.lazygit = {
        enable = true;
        settings = {
          git.paging.pager = "delta --paging=never";
        };
      };
    };
}
