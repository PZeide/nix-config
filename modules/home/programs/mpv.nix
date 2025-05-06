{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.mpv = with lib; {
    enable = mkEnableOption "mpv video player";

    screenshotSaveDir = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/Pictures/Screenshots";
      description = "Save directory for screenshots.";
    };

    screenshotFileName = mkOption {
      type = types.str;
      default = "mpv_%f-%wH.%wM.%wS.%wT-#%#00n";
      description = "Filename of the screenshot (supports https://mpv.io/manual/master/#options-screenshot-template).";
    };
  };

  config = let
    selfConfig = config.zeide.programs.mpv;
  in
    lib.mkIf selfConfig.enable {
      programs.mpv = {
        enable = true;

        scripts = with pkgs.mpvScripts; [
          mpris
          modernz
          thumbfast
        ];

        config = {
          # General
          keep-open = true;
          save-position-on-quit = true;
          cursor-autohide = 500;
          osc = false;
          border = false;

          # Video
          profile = "gpu-hq";
          vo = "gpu-next";
          gpu-api = "vulkan";

          # Audio
          alang = "ja,jp,jpn,en,eng,fr,fra,fre";
          volume-max = 100;
          volume = 70;

          # Subtitles
          slang = "en,eng,fr,fra,fre";
          sub-auto = "fuzzy";
          sub-gauss = 1.0;

          # Screenshot
          screenshot-format = "webp";
          screenshot-high-bit-depth = true;
          screenshot-dir = "${selfConfig.screenshotSaveDir}";
          screenshot-template = "${selfConfig.screenshotFileName}";
        };

        bindings = {
          z = "ignore";
          k = "cycle audio-exclusive";
          w = "no-osd cycle sub-visibility";
          s = "cycle sub";
          S = "cycle sub down";

          F1 = "add sub-delay -0.1";
          F2 = "add sub-delay +0.1";

          F5 = "no-osd screenshot";

          WHEEL_UP = "add volume 2";
          WHEEL_DOWN = "add volume -2";
          RIGHT = "seek 2 exact";
          LEFT = "seek -2 exact";
          UP = "seek 5 exact";
          DOWN = "seek -5 exact";
          "Ctrl+RIGHT" = "seek 20 exact";
          "Ctrl+LEFT" = "seek -20 exact";
        };
      };

      stylix.targets.mpv.enable = true;
    };
}
