{
  config,
  lib,
  inputs,
  system,
  ...
}:

{
  imports = [ inputs.walker.homeManagerModules.default ];

  programs.walker = {
    enable = true;

    config = {
      app_launch_prefix = "uwsm app -- ";

      activation_mode = {
        labels = "123456789";
      };

      builtins = {
        applications = {
          history = true;
          show_icon_when_single = true;
          show_sub_when_single = true;
          weight = 5;
          prioritize_new = true;
        };

        clipboard = {
          switcher_only = true;
          image_height = 300;
        };

        emojis = {
          switcher_only = true;
        };

        runner = {
          history = true;
          weight = 4;
          generic_entry = false;
        };

        ssh = {
          switcher_only = true;
          history = true;
        };

        switcher = {
          prefix = "/";
        };
      };

      disabled = [
        "ai"
        "commands"
        "custom_commands"
        "dmenu"
        "finder"
        "websearch"
        "windows"
      ];

      list = {
        max_entries = 30;
        show_initial_entries = true;
        single_click = true;
        placeholder = "";
      };

      search = {
        delai = 0;
        force_keyboard_focus = true;
        placeholder = "Search...";
      };

      terminal = "kitty";
    };

    theme = {
      layout = {
        ui = {
          anchors = {
            top = false;
            bottom = false;
            left = false;
            right = false;
          };

          fullscreen = false;
          ignore_exclusive = true;

          window = {
            box = {
              h_align = "center";
              v_align = "center";
              orientation = "vertical";

              scroll = {
                list = {
                  marker_color = config.lib.stylix.colors.withHashtag.base09;
                  min_height = 500;
                  max_height = 500;

                  item = {
                    icon = {
                      pixel_size = 32;
                    };
                  };

                  always_show = true;
                };
              };
            };
          };
        };
      };

      style =
        with config.lib.stylix.colors.withHashtag;
        with config.stylix.fonts;
        ''
          * {
            all: unset;
            font-family: ${sansSerif.name};
            font-size: ${toString sizes.applications}pt;
            color: ${base07};
            box-shadow: none;
          }

          #window {
            background: ${base00}96;
            border-radius: 15px;
            border: 3px solid ${base0D};
          }

          #box {
            padding: 15px;
          }

          #search {
            background: none;
            margin-bottom: 30px;
          }

          #password,
          #input,
          #typeahead {
            background: rgba(0, 0, 0, 0.3);
            border: 1px solid ${base0D};
            border-radius: 7.5px;
            padding: 10px;
            outline: none;
          }

          #input > *:first-child,
          #typeahead > *:first-child {
            margin-right: 5px;
          }

          #spinner {}

          #typeahead {
            opacity: 0.5;
          }

          #input placeholder {
            opacity: 0.5;
          }

          #list {
            background: none;
          }

          child {
            margin: 0 10px 5px;
          }

          child:selected {
            background: ${base0B}3c;
            border-radius: 7.5px;
          }

          #item {
            border-radius: 7.5px;
            padding: 5px;
          }

          #icon {
            padding-right: 10px;
          }

          #textwrapper {}

          #label {}

          #sub {
            opacity: 0.5;
          }

          #activationlabel {
            opacity: 0.5;
          }

          .activation #activationlabel {
            opacity: 1;
            color: ${base0D};
          }

          .activation #textwrapper,
          .activation #search {
            opacity: 0.5;
          }
        '';
    };
  };

  systemd.user.services.walker = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Unit = {
      ConditionEnvironment = "WAYLAND_DISPLAY";
      Description = "Walker";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${lib.getExe inputs.walker.packages."${system}".default} --gapplication-service";
      Restart = "always";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
