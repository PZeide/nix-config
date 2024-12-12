{ pkgs, lib, ... }:

{
  home = {
    packages = [ pkgs.grc ];

    activation = {
      createTideConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD ${pkgs.fish}/bin/fish -c "tide configure \
          --auto \
          --style=Lean \
          --prompt_colors='16 colors' \
          --show_time='12-hour format' \
          --lean_prompt_height='Two lines' \
          --prompt_connection=Disconnected \
          --prompt_spacing=Sparse \
          --icons='Few icons' \
          --transient=Yes"
      '';
    };
  };

  programs = {
    fish = {
      enable = true;

      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';

      plugins = with pkgs.fishPlugins; [
        {
          name = "tide";
          src = tide.src;
        }
        {
          name = "sponge";
          src = sponge.src;
        }
        {
          name = "grc";
          src = grc.src;
        }
        {
          name = "autopair";
          src = autopair.src;
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
}
