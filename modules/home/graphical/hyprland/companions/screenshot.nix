{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}: {
  options.zeide.graphical.hyprland.companions.screenshot = with lib; {
    enable = mkEnableOption "screenshot utility with annotation tool tailored for hyprland";

    saveDir = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/Pictures/Screenshots";
      description = "Save directory for screenshots.";
    };

    fileName = mkOption {
      type = types.str;
      default = "satty_%Y-%m-%d_%H:%M:%S.png";
      description = "Filename of the screenshot (supports https://docs.rs/chrono/latest/chrono/format/strftime/index.html).";
    };
  };

  config = let
    selfConfig = config.zeide.graphical.hyprland.companions.screenshot;
  in
    lib.mkIf selfConfig.enable {
      xdg.configFile."${config.xdg.configHome}/satty/config.toml".text = ''
        [general]
        # Start Satty in fullscreen mode
        fullscreen = false
        # Exit directly after copy/save action
        early-exit = true
        # Select the tool on startup [possible values: pointer, crop, line, arrow, rectangle, text, marker, blur, brush]
        initial-tool = "pointer"
        # Increase or decrease the size of the annotations
        annotation-size-factor = 1
        # Filename to use for saving action: https://docs.rs/chrono/latest/chrono/format/strftime/index.html
        output-filename = "${selfConfig.saveDir}/${selfConfig.fileName}"

        # Font to use for text annotations
        [font]
        family = "${osConfig.zeide.graphical.fonts.sansSerif.name}"
        style = "Bold"
      '';

      home = {
        activation.sattyDirCreate =
          lib.hm.dag.entryAfter ["writeBoundary"]
          ''
            mkdir -p "${selfConfig.saveDir}"
            chown ${config.home.username} "${selfConfig.saveDir}"
          '';

        packages = [
          (pkgs.writeShellApplication
            {
              name = "screenshot";
              runtimeInputs = with pkgs; [hyprshot satty];
              text = ''
                MODE=''${1:-region}
                hyprshot --mode "$MODE" --raw | satty --filename -
              '';
            })
        ];
      };
    };
}
