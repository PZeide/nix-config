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
      wallpaper = asset "wallpapers/jane.jpg";
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
          wrapAppUnit = app: "${lib.getExe pkgs.zeide.app2unit} -s a -- ${app}";
        in [
          "$mainMod, Q, exec, ${wrapAppUnit "kitty"}"
          "$mainMod, E, exec, ${wrapAppUnit "nautilus"}"
          "$mainMod, B, exec, ${wrapAppUnit "zen"}"
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
          zeide-shell.enable = false;
        };
      };
    };

    shell.fish.enable = true;

    programs = {
      starship = {
        enable = true;
        enableNerdIcons = true;
      };

      zen-browser.enable = true;

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
      };

      helix = {
        enable = true;
        theme = builtins.fromTOML (builtins.readFile (asset "helix/themes/kaolin-dark-transparent.toml"));
      };

      kitty.enable = true;

      nautilus = {
        enable = true;
        enableVideoThumbnailer = true;
        openTerminalAction = "kitty";
        bookmarks = [];
      };

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
    };

    services = {
      clipboard.enable = true;
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
