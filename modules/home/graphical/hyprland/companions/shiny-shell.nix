{
  lib,
  config,
  inputs,
  ...
}: {
  options.zeide.graphical.hyprland.companions.shiny-shell = with lib; {
    enable = mkEnableOption "shiny-shell";
  };

  imports = [inputs.shiny-shell.homeManagerModules.default];

  config = let
    selfConfig = config.zeide.graphical.hyprland.companions.shiny-shell;
  in
    lib.mkIf selfConfig.enable {
      programs.shiny-shell = {
        enable = true;

        settings = {
          appearance = {
            color = with config.lib.stylix.colors.withHashtag; {
              bgPrimary = base00;
              bgSecondary = base01;
              bgSelection = base02;

              fgPrimary = base05;
              fgSecondary = base04;

              accentPrimary = base08;
              accentSecondary = base09;
            };

            font.family = with config.stylix.fonts; {
              sans = sansSerif.name;
              mono = monospace.name;
            };
          };

          bar.enabled = true;

          brightness = {
            enabled = true;
            natural = true;
            smooth = true;
          };

          idle = {
            enabled = true;
            items = [
              {
                timeout = 300;
                actions = ["setbrightness,0.3"];
              }
              {
                timeout = 600;
                actions = ["dpms"];
              }
              {
                timeout = 900;
                actions = ["suspend"];
              }
            ];
          };

          launcher = {
            enabled = true;
            applications.useSystemd = true;
            calculator.enabled = true;

            webSearch = {
              enabled = true;
              url = "https://kagi.com/search?q=%s";
            };
          };

          locale = {
            timeFormat = "h:mm a";
            dateFullFormat = "dddd d MMMM";
            dateShortFormat = "ddd d MMM";
            temperatureUnit = "celsius";
          };

          location.enabled = true;

          lockScreen = {
            enabled = true;
            lockOnStart = true;
            lockOnSuspend = true;
          };

          overview.enabled = true;

          player = {
            blacklist = [];
            preferred = ["cider"];
          };

          wallpaper = {
            enabled = true;
            path = "${config.stylix.image}";
            foreground = true;
          };
        };
      };
    };
}
