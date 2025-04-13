{
  asset,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  zeide = {
    theme = {
      wallpaper = asset "wallpapers/jane-2.jpg";
      polarity = "dark";

      gtk = {
        enable = true;
        iconFlavor = "mocha";
        iconAccent = "red";
      };
    };

    graphical = {
      hyprland = {
        enable = true;
        monitors = ["eDP-1, 1920x1080@144, 0x0, 1"];
        keyboardLayout = "us";
        keyboardVariant = "intl";

        perDeviceConfigurations = [
          {
            name = "ite-tech.-inc.-ite-device(8910)-keyboard";
            kb_layout = "fr";
            kb_variant = "";
          }
          {
            name = "elan06fa:00-04f3:31dd-mouse";
            accel_profile = "adpative";
          }
        ];

        binds.extra = let
          wrapAppUnit = app: "${lib.getExe pkgs.app2unit} -s a -- ${app}";
        in [
          "$mainMod, Q, exec, ${wrapAppUnit "kitty"}"
          "$mainMod, E, exec, ${wrapAppUnit "nautilus"}"
          "$mainMod, B, exec, ${wrapAppUnit "zen-beta"}"
        ];

        plugins = {
          hyprsplit.enable = true;
          hyprexpo.enable = true;
        };

        companions = {
          hyprpaper.enable = true;
          hypridle.enable = true;
          hyprlock = {
            enable = true;
            autostartOnGraphical = true;
          };
          hyprpicker.enable = true;
          zeide-shell.enable = true;
        };
      };
    };

    shell.fish.enable = true;

    programs = {
      cli = {
        essentials.enable = true;
        fastfetch.enable = true;
        development.enable = true;
      };

      helix = {
        enable = true;
        theme = {
          # https://github.com/helix-editor/helix/blob/master/runtime/themes/hex_steel.toml
          # TODO use hex_steel
          inherits = "bogster";

          "ui.background" = {
            bg = "none";
          };

          "ui.linenr" = {
            fg = "bogster-fg0";
          };

          "ui.statusline" = {
            fg = "bogster-fg1";
            bg = "none";
          };

          "ui.statusline.inactive" = {
            fg = "bogster-fg0";
            bg = "none";
          };

          "ui.popup" = {
            bg = "none";
          };

          "ui.window" = {
            bg = "none";
          };

          "ui.help" = {
            bg = "none";
            fg = "bogster-fg1";
          };

          "ui.statusline.normal" = {
            fg = "bogster-base1";
            bg = "none";
            modifiers = ["bold"];
          };

          "ui.statusline.insert" = {
            fg = "bogster-base1";
            bg = "none";
            modifiers = ["bold"];
          };

          "ui.statusline.select" = {
            fg = "bogster-base1";
            bg = "none";
            modifiers = ["bold"];
          };

          "ui.menu" = {
            fg = "bogster-fg1";
            bg = "none";
          };

          "ui.menu.selected" = {
            bg = "bogster-base3";
          };
        };
      };

      kitty.enable = true;

      vscodium = {
        enable = true;

        colorTheme = {
          name = "Bearded Theme Black & Ruby";
          package = inputs.nix-vscode-extensions.extensions.${system}.vscode-marketplace.beardedbear.beardedtheme;
        };

        iconTheme = {
          name = "bearded-icons";
          package = inputs.nix-vscode-extensions.extensions.${system}.vscode-marketplace.beardedbear.beardedicons;
        };
      };

      zen-browser.enable = true;
    };

    services = {
      clipboard.enable = true;
      keyring.enable = true;
      udiskie.enable = true;
      wakatime.enable = true;
    };
  };
}
