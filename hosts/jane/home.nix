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
  zeide = {
    theme = {
      wallpaper = asset "wallpapers/zani.jpg";
      polarity = "dark";

      gtk = {
        enable = true;
        iconFlavor = "mocha";
        iconAccent = "rosewater";
      };

      qt.enable = true;
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
          "$mainMod, E, exec, ${wrapAppUnit "nautilus"}"
          "$mainMod, B, exec, ${wrapAppUnit "zen-beta"}"

          "$mainMod, X, togglespecialworkspace, azurlane"
          "$mainMod, Z, togglespecialworkspace, cider"
        ];

        rules = {
          windows = [
            "fullscreen, class:^(waydroid.com.YoStarEN.AzurLane)$"
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
          hyprpaper.enable = true;

          hypridle = {
            enable = true;
            dimBacklight = true;
          };

          hyprlock = {
            enable = true;
            autostartOnGraphical = true;
          };

          hyprpicker.enable = true;
          screenshot.enable = true;
          zeide-shell.enable = false;
        };
      };
    };

    shell.fish.enable = true;

    programs = {
      gaming = {
        bottles.enable = true;
        mangohud.enable = true;

        prism-launcher = {
          enable = true;
          enableAllJdks = true;
        };

        waydroid.hideDefaultEntries = true;
      };

      starship = {
        enable = true;
        enableNerdIcons = true;
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

      daily = {
        seahorse.enable = true;
        mission-center.enable = true;
        overskride.enable = true;
        nm-applet.enable = true;
        disk-utility.enable = true;
        loupe.enable = true;
        file-roller.enable = true;
        papers.enable = true;
        pods.enable = true;
        cider.enable = true;
        fragments.enable = true;
        goofcord.enable = true;
        proton-pass.enable = true;
        proton-vpn.enable = true;
      };

      helix = {
        enable = true;
        theme = builtins.fromTOML (builtins.readFile (asset "helix/themes/kaolin-dark-transparent.toml"));
      };

      kitty.enable = true;
      mpv.enable = true;

      nautilus = {
        enable = true;
        enableVideoThumbnailer = true;
        addUserDirsToSidebar = true;
        openTerminalAction = "kitty";
        bookmarks = [];
      };

      obs-studio.enable = true;

      vscodium = {
        enable = true;

        colorTheme = {
          name = "Bearded Theme Anthracite";
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
          directory = ["org.gnome.Nautilus.desktop"];
          office = [];
          pdf = ["org.gnome.Papers.desktop"];
          terminal = ["kitty.desktop"];
          archive = ["org.gnome.FileRoller.desktop"];
          discord = [];
        };
      };
    };
  };
}
