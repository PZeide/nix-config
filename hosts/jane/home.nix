{
  asset,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: let
  appLaunchPrefix = "${lib.getExe pkgs.zeide.app2unit} -s a --";
  wrapAppUnit = app: "${appLaunchPrefix} ${app}";
in {
  home.packages = [pkgs.jetbrains.idea-community];

  zeide = {
    theme = {
      wallpaper = asset "wallpapers/yuzuha.jpg";
      polarity = "dark";

      gtk.enable = true;

      qt = {
        enable = true;
        kvantumTheme = {
          package = pkgs.catppuccin-kvantum.override {
            variant = "macchiato";
            accent = "maroon";
          };
          name = "catppuccin-macchiato-maroon";
        };
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

        binds.extra = [
          "$mainMod, HOME, exec, ${wrapAppUnit "screenshot region"}"
          "$mainMod SHIFT, HOME, exec, ${wrapAppUnit "screenshot window"}"

          "$mainMod, SPACE, exec, ${wrapAppUnit "anyrun"}"
          "$mainMod, Q, exec, ${wrapAppUnit "kitty"}"
          "$mainMod, E, exec, ${wrapAppUnit "yazi"}"
          "$mainMod, B, exec, ${wrapAppUnit "zen-beta"}"

          "$mainMod, X, togglespecialworkspace, azurlane"
          "$mainMod, Z, togglespecialworkspace, cider"
        ];

        rules = {
          windows = [
            "workspace special:azurlane, class:^(waydroid.com.YoStarEN.AzurLane)$"
            "workspace special:cider, class:^(Cider)$"
          ];

          workspaces = [
            "special:azurlane, on-created-empty:${wrapAppUnit "waydroid app launch com.YoStarEN.AzurLane"}"
            "special:cider, on-created-empty:${wrapAppUnit "cider"}"
          ];
        };

        plugins = {
          hyprsplit.enable = true;
          hyprexpo.enable = true;
        };

        companions = {
          hypridle = {
            enable = true;
            dimBacklight = true;
          };

          hyprpicker.enable = true;
          screenshot.enable = true;

          shiny-shell = {
            enable = true;
            autostartOnGraphical = true;
          };
        };
      };
    };

    shell.fish.enable = true;

    programs = {
      gaming = {
        bottles.enable = true;
        lunar-client.enable = true;
        mangohud.enable = true;
        osu-lazer.enable = true;

        prism-launcher = {
          enable = true;
          enableAllJdks = true;
        };
      };

      starship = {
        enable = true;
        enableNerdIcons = true;
      };

      tui = {
        bluetui.enable = true;
        btop.enable = true;
        impala.enable = true;
        lazygit.enable = true;
        nyaa.enable = true;
        rustmission.enable = true;

        yazi = {
          enable = true;
          enableFileChooser = true;
          flavor = {
            package = pkgs.zeide.yazi-flavors.catppuccin-mocha;
            name = "catppuccin-mocha";
          };
          extraHops = [
            {
              key = "D";
              path = "/mnt/data";
              desc = "Data drive";
            }
          ];
        };
      };

      anyrun = {
        enable = true;
        preprocessScript = let
          script = pkgs.writeScript "anyrun-preprocess-script" ''
            shift # Remove term|no-term
            echo "${appLaunchPrefix} $*"
          '';
        in "${script}";
      };

      cli = {
        essentials.enable = true;
        fastfetch.enable = true;
        development.enable = true;
      };

      graphical = {
        loupe = true;
        papers = true;
        cider = true;
        equibop = true;
        proton-pass = true;
        proton-vpn = true;
        teams = true;

        webapps = {
          keychronLauncher = true;
          lamzuAurora = true;
        };
      };

      helix = {
        enable = true;
        theme = {
          inherits = "snazzy";
          "ui.background" = {};
        };
      };

      kitty.enable = true;

      mpv = {
        enable = true;
        useOpenGL = true;
      };

      obs-studio.enable = true;

      vscodium = {
        enable = true;

        colorTheme = {
          name = "Bearded Theme Coffee Reversed";
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

      easyeffects = {
        enable = true;
        enableDefaultPreset = true;
      };

      keyring.enable = true;

      librepods = {
        enable = true;
        phoneMacAddress = "28:2D:7F:DF:BC:76";
      };

      polkit-agent.enable = true;
      udiskie.enable = true;
      wakatime.enable = true;

      xdg = {
        enableUserDirs = true;
        defaultApps = {
          browser = ["zen.desktop"];
          text = ["Helix.desktop"];
          image = ["org.gnome.Loupe.desktop"];
          audio = ["mpv.desktop"];
          video = ["mpv.desktop"];
          directory = ["yazi.desktop"];
          office = [];
          pdf = ["org.gnome.Papers.desktop"];
          terminal = ["kitty.desktop"];
          archive = [];
          discord = [];
        };
      };
    };
  };
}
