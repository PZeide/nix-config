{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;

    scripts = with pkgs.mpvScripts; [
      mpris
      modernx
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
      sub-gray = true;

      # Screenshot
      screenshot-format = "webp";
      screenshot-high-bit-depth = true;
      screenshot-dir = "$XDG_PICTURES_DIR";
      screenshot-template = "%f-%wH.%wM.%wS.%wT-#%#00n";
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
}
