{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.cli = with lib; {
    essentials = {
      enable = mkEnableOption "cli essentials";

      gitName = mkOption {
        type = types.str;
        default = "Zeide";
        description = ''
          Default username of the git user.
        '';
      };

      gitEmail = mkOption {
        type = types.str;
        default = "git.lagging775@passmail.net";
        description = ''
          Default email of the git user.
        '';
      };
    };

    fastfetch.enable = mkEnableOption "fastfetch tool";

    development.enable = mkEnableOption "misc development tools";
  };

  config = let
    selfConfig = config.zeide.programs.cli;
  in
    lib.mkMerge [
      (lib.mkIf selfConfig.essentials.enable {
        home = {
          packages = [pkgs.grc];
          shellAliases = {
            g = "git";
          };
        };

        programs = {
          bat.enable = true;
          jq.enable = true;
          zoxide.enable = true;
          fzf.enable = true;
          fd.enable = true;
          ripgrep.enable = true;

          eza = {
            enable = true;
            icons = "auto";
          };

          direnv = {
            enable = true;
            nix-direnv.enable = true;
          };

          git = {
            enable = true;

            userName = selfConfig.essentials.gitName;
            userEmail = selfConfig.essentials.gitEmail;

            signing = {
              key = "~/.ssh/id_ed25519.pub";
              signByDefault = true;
            };

            aliases = {
              a = "add";
              aa = "add -A";
              b = "branch";
              ba = "branch -a";
              c = "commit -m";
              ca = "commit -am";
              pl = "pull";
              ps = "push";
              co = "checkout";
              cob = "checkout -b";
              contributors = "shortlog -nse";
              d = "difftool";
              ds = "difftool --staged";
              lg = "log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'";
              remotes = "remote -v";
              s = "status -sb";
              undo = "reset HEAD~1";
            };

            extraConfig = {
              gpg.format = "ssh";
              init.defaultBranch = "main";
              color.ui = true;

              push = {
                default = "simple";
                autoSetupRemote = true;
              };
            };

            delta = {
              enable = true;

              options = {
                navigate = true;
                side-by-side = true;
                true-color = "never";

                features = "unobtrusive-line-numbers decorations";
                unobtrusive-line-numbers = {
                  line-numbers = true;
                  line-numbers-left-format = "{nm:>4}│";
                  line-numbers-right-format = "{np:>4}│";
                  line-numbers-left-style = "grey";
                  line-numbers-right-style = "grey";
                };

                decorations = {
                  commit-decoration-style = "bold grey box ul";
                  file-style = "bold blue";
                  file-decoration-style = "ul";
                  hunk-header-decoration-style = "box";
                };
              };
            };
          };
        };

        stylix.targets = {
          bat.enable = true;
          fzf.enable = true;
        };
      })

      (lib.mkIf selfConfig.fastfetch.enable {
        programs.fastfetch = {
          enable = true;

          settings = {
            logo = {
              type = "none";
            };

            display = {
              separator = "  ";
            };

            modules = [
              {
                type = "title";
                format = "{#1}╭───────────── {#}{user-name-colored} ─────────";
              }
              {
                type = "custom";
                format = "{#1}│ {#}System Information";
              }
              {
                type = "os";
                key = "{#separator}│  {#keys}󰍹 OS";
              }
              {
                type = "kernel";
                key = "{#separator}│  {#keys}󰒋 Kernel";
              }
              {
                type = "uptime";
                key = "{#separator}│  {#keys}󰅐 Uptime";
              }
              {
                type = "packages";
                key = "{#separator}│  {#keys}󰏖 Packages";
                format = "{all}";
              }
              {
                type = "custom";
                format = "{#1}│";
              }
              {
                type = "custom";
                format = "{#1}│ {#}Desktop Environment";
              }
              {
                type = "de";
                key = "{#separator}│  {#keys}󰧨 DE";
              }
              {
                type = "wm";
                key = "{#separator}│  {#keys}󱂬 WM";
              }
              {
                type = "wmtheme";
                key = "{#separator}│  {#keys}󰉼 Theme";
              }
              {
                type = "display";
                key = "{#separator}│  {#keys}󰹑 Resolution";
              }
              {
                type = "shell";
                key = "{#separator}│  {#keys}󰞷 Shell";
              }
              {
                type = "custom";
                format = "{#1}│";
              }
              {
                type = "custom";
                format = "{#1}│ {#}Hardware Information";
              }
              {
                type = "cpu";
                key = "{#separator}│  {#keys}󰻠 CPU";
              }
              {
                type = "gpu";
                key = "{#separator}│  {#keys}󰢮 GPU";
              }
              {
                type = "memory";
                key = "{#separator}│  {#keys}󰍛 Memory";
              }
              {
                type = "disk";
                key = "{#separator}│  {#keys}󰋊 Disk (/)";
                folders = "/";
              }
              {
                type = "custom";
                format = "{#1}│";
              }
              {
                type = "colors";
                key = "{#separator}│";
                symbol = "circle";
              }
              {
                type = "custom";
                format = "{#1}╰───────────────────────────────────────────────────";
              }
            ];
          };
        };
      })

      (lib.mkIf selfConfig.development.enable {
        home.packages = with pkgs; [
          dive
          kubectl
        ];
      })
    ];
}
