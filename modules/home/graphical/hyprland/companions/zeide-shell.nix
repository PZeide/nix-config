{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  options.zeide.graphical.hyprland.companions.zeide-shell = with lib; {
    enable = mkEnableOption "zeide-shell powered by ags";
  };

  config = let
    selfConfig = config.zeide.graphical.hyprland.companions.zeide-shell;
  in
    lib.mkIf selfConfig.enable {
      /*
        systemd.user.services.zeide-shell = {
        Unit = {
          Description = "zeide-shell";
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };

        Service = {
          Type = "simple";
          ExecStart = "${lib.getExe inputs.zeide-shell.packages.${system}.default}";
          Restart = "always";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };

        Install.WantedBy = ["graphical-session.target"];
      };
      */

      xdg.configFile."quickshell/caelestia".source = pkgs.fetchFromGitHub {
        owner = "caelestia-dots";
        repo = "shell";
        rev = "8af10012b9527e3e4a894e4a3c0fd8ea9ac0e132";
        hash = "sha256-wyx+CjtyryzULsWAJ9GHczNHBBJPNOlGjuAbG92UvOQ=";
      };

      wayland.windowManager.hyprland.settings = {
        layerrule = [
          "noanim, caelestia-(launcher|osd|notifications|border-exclusion)"
          "animation fade, caelestia-(drawers|background)"
          "order 1, caelestia-border-exclusion"
          "order 2, caelestia-bar"
        ];
      };

      home.packages =
        [
          inputs.quickshell.packages.${system}.default
        ]
        ++ (with pkgs; [
          app2unit
          material-symbols
          nerd-fonts.jetbrains-mono
          ibm-plex
          curl
          jq
          fd
          cava
          bluez
          ddcutil
          brightnessctl
          imagemagick
        ])
        ++ (with pkgs.python313Packages; [
          aubio
          pyaudio
          numpy
        ]);
    };
}
