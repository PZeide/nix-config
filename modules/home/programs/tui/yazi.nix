{
  config,
  lib,
  pkgs,
  ...
}: let
  hopType = lib.types.submodule {
    options = {
      key = lib.mkOption {
        type = lib.types.str;
        description = "The key to trigger the hop";
      };
      path = lib.mkOption {
        type = lib.types.str;
        description = "The path to hop to";
      };
      desc = lib.mkOption {
        type = lib.types.str;
        description = "A description for the hop";
      };
    };
  };

  yaziFlavorType = lib.types.submodule {
    options = {
      package = lib.mkOption {
        type = lib.types.package;
        description = "The package of the flavor";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the flavor";
      };
    };
  };
in {
  options.zeide.programs.tui.yazi = with lib; {
    enable = mkEnableOption "yazi (file manager)";
    enableFileChooser = mkEnableOption "yazi file chooser";

    flavor = mkOption {
      type = with types; nullOr yaziFlavorType;
      default = null;
      description = "Yazi flavor to use";
    };

    extraHops = mkOption {
      type = types.listOf hopType;
      default = [];
      description = "Additional 'hops' for the bunny plugin in Yazi";
    };
  };

  config = let
    selfConfig = config.zeide.programs.tui.yazi;
  in
    lib.mkIf selfConfig.enable {
      home.packages = with pkgs; [
        ripdrag
        wl-clipboard
        glow
        hexyl
        mediainfo
        ouch
        trash-cli
      ];

      xdg = lib.mkIf selfConfig.enableFileChooser {
        configFile."xdg-desktop-portal-termfilechooser/config" = {
          text = ''
            [filechooser]
            cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
            env=TERMCMD=${pkgs.kitty}/bin/kitty --title FileChooser
            default_dir=$HOME
            open_mode=last
            save_mode=last
          '';

          recursive = true;
        };

        portal = {
          extraPortals = [pkgs.xdg-desktop-portal-termfilechooser];

          config = {
            common."org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
            hyprland."org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
          };
        };
      };

      programs.yazi = {
        enable = true;
        enableFishIntegration = true;
        shellWrapperName = "y";

        flavors = lib.mkIf (selfConfig.flavor != null) {
          ${selfConfig.flavor.name} = selfConfig.flavor.package;
        };

        theme.flavor = lib.mkIf (selfConfig.flavor != null) {
          dark = selfConfig.flavor.name;
          light = selfConfig.flavor.name;
        };

        settings = {
          show_hidden = false;
          show_symlink = true;

          mgr.ratio = [
            1
            3
            4
          ];

          preview = {
            wrap = "yes";
            tab_size = 2;
            max_width = 1000;
            max_height = 1000;
            image_delay = 0;
            image_filter = "triangle";
            image_quality = 75;
          };

          opener = {
            extract = [
              {
                run = "ouch d -y \"$@\"";
                desc = "Extract here with ouch";
              }
            ];
          };

          plugin = {
            prepend_preloaders =
              [
                {
                  mime = ["{audio,video,image}/*" "application/subrip" "application/postscript"];
                  run = ["mediainfo"];
                }
              ]
              |> map (lib.attrsets.cartesianProduct)
              |> lib.lists.concatLists;

            prepend_previewers =
              [
                {
                  name = ["*.md"];
                  run = ["piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark \"$1\""];
                }
                {
                  mime = ["{audio,video,image}/*" "application/subrip" "application/postscript"];
                  run = ["mediainfo"];
                }
              ]
              |> map (lib.attrsets.cartesianProduct)
              |> lib.lists.concatLists;

            append_previewers =
              [
                {
                  name = ["*"];
                  run = ["piper -- hexyl --border=none --terminal-width=$w \"$1\""];
                }
              ]
              |> map (lib.attrsets.cartesianProduct)
              |> lib.lists.concatLists;
          };
        };

        initLua = ''
          -- Visual
          require("full-border"):setup({
            type = ui.Border.ROUNDED,
          })
          require("starship"):setup()

          -- Utilities
          require("bunny"):setup({
            hops = {
              { key = "/", path = "/",           desc = "System root"     },
              { key = "t", path = "/tmp",        desc = "Temporary files" },
              { key = "h", path = "~",           desc = "Home"            },
              { key = "d", path = "~/Documents", desc = "Documents"       },
              -- Dynamically added hops from extraHops
              ${lib.concatStringsSep "\n" (lib.map (hop: "{ key = \"${hop.key}\", path = \"${hop.path}\", desc = \"${hop.desc}\" },") selfConfig.extraHops)}
            },
            notify = true,
          })
          require("restore"):setup({
            show_confirm = true,
          })
          require("copy-file-contents"):setup({
            notification = true,
          })

          -- Other
          Status:children_add(function()
            local h = cx.active.current.hovered
            if not h or ya.target_family() ~= "unix" then
              return ""
            end

            return ui.Line {
              ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
              ":",
              ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
              " ",
            }
          end, 500, Status.RIGHT)
        '';

        keymap = {
          mgr.prepend_keymap = [
            {
              on = "y";
              run = ["shell -- for path in \"$@\"; do echo \"file://$path\"; done | wl-copy -t text/uri-list" "yank"];
              desc = "Yank and copy to system clipboard";
            }
            {
              on = "x";
              run = ["shell -- for path in \"$@\"; do echo \"file://$path\"; done | wl-copy -t text/uri-list" "yank --cut"];
              desc = "Yank (cut) and copy to system clipboard";
            }
            {
              on = "<Esc>";
              run = "close";
              desc = "Cancel input";
            }
            {
              on = ["<C-n>"];
              run = "shell 'ripdrag \"$@\" -x 2>/dev/null &' --confirm";
            }
            {
              on = "!";
              for = "unix";
              run = "shell \"$SHELL\" --block";
              desc = "Open $SHELL here";
            }
            {
              on = "C";
              run = "plugin ouch";
              desc = "Compress select files/folders";
            }
            {
              on = "T";
              run = "plugin toggle-pane max-preview";
              desc = "Maximize or restore the preview pane";
            }
            {
              on = "b";
              run = "plugin bunny";
              desc = "Show hops";
            }
            {
              on = ";";
              run = "plugin bunny";
              desc = "Show hops";
            }
            {
              on = ["c" "m"];
              run = "plugin chmod";
              desc = "Chmod selected files";
            }
            {
              on = "u";
              run = "plugin restore";
              desc = "Restore last deleted files/folders";
            }
            {
              on = "<A-y>";
              run = "plugin copy-file-contents";
              desc = "Copy contents of file";
            }
            {
              on = ["c" "i"];
              run = "plugin lazygit";
              desc = "Execute lazygit";
            }
          ];

          # = 1024*1024*1024 = 1024MB (required for large files like Adobe Illustrator, Adobe Photoshop, etc)
          tasks.image_alloc = 1073741824;
        };

        plugins = with pkgs.zeide.yazi-plugins; {
          # Previewers
          piper = piper;
          mediainfo = mediainfo;
          ouch = ouch;

          # Visual
          toggle-pane = toggle-pane;
          full-border = full-border;
          starship = starship;

          # Utilities
          bunny = bunny;
          chmod = chmod;
          restore = restore;
          copy-file-contents = copy-file-contents;
          lazygit = lazygit;
        };
      };
    };
}
