{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.shell.fish = with lib; {
    enable = mkEnableOption "fish shell";
  };

  config = let
    selfConfig = config.zeide.shell.fish;
  in
    lib.mkIf selfConfig.enable {
      programs = {
        fish = {
          enable = true;

          interactiveShellInit = ''
            set fish_greeting # Disable greeting
          '';

          plugins = with pkgs.fishPlugins; [
            {
              name = "grc";
              src = grc.src;
            }
            {
              name = "pisces";
              src = pisces.src;
            }
            {
              name = "sponge";
              src = sponge.src;
            }
            {
              name = "fzf.fish";
              src = fzf-fish.src;
            }
            {
              name = "fish-you-should-use";
              src = fish-you-should-use.src;
            }
          ];
        };

        # Bash is still our login shell so we use a script to start fish if requirements are met
        # see https://nixos.wiki/wiki/Fish
        bash = {
          enable = true;
          initExtra = ''
            if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
            then
              shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
              exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
            fi
          '';
        };
      };
    };
}
