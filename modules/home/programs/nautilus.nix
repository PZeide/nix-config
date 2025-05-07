{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.nautilus = with lib; {
    enable = mkEnableOption "nautilus file explorer";
    enableVideoThumbnailer = mkEnableOption "video thumbnailer (powerered by ffmpeg-thumbnailer)";

    addUserDirsToSidebar = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to add user directories in siderbar";
    };

    openTerminalAction = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        Terminal to open with 'Open in terminal' action.
      '';
    };

    bookmarks = mkOption {
      type = with types; listOf str;
      default = [];
      description = ''
        A list of bookmarks shown in the sidebar.
      '';
    };
  };

  config = let
    selfConfig = config.zeide.programs.nautilus;

    # To allow the "Audio and Video Properties" to work correctly
    nautilusWithGst = pkgs.nautilus.overrideAttrs (super: {
      buildInputs =
        super.buildInputs
        ++ (with pkgs.gst_all_1; [
          gst-plugins-good
          gst-plugins-bad
        ]);
    });

    nautilusEnv = pkgs.buildEnv {
      name = "nautilus-env";

      paths = with pkgs; [
        nautilusWithGst
        nautilus-python
        nautilus-open-any-terminal
      ];
    };
  in
    lib.mkIf selfConfig.enable {
      assertions = [
        {
          assertion = osConfig.zeide.services.gnome.fixNautilusExtensions;
          message = "osConfig.zeide.services.gnome.fixNautilusExtensions is required to enable nautilus.";
        }
      ];

      home = {
        packages = with pkgs;
          [
            nautilusEnv
            # Used to open default apps in terminal
            xdg-terminal-exec
          ]
          ++ lib.optional selfConfig.enableVideoThumbnailer ffmpegthumbnailer;

        sessionVariables = {
          NAUTILUS_4_EXTENSION_DIR = "${nautilusEnv}/lib/nautilus/extensions-4";
        };
      };

      dconf.settings = lib.mkIf (selfConfig.openTerminalAction != null) {
        "com/github/stunkymonkey/nautilus-open-any-terminal" = {
          "terminal" = selfConfig.openTerminalAction;
        };
      };

      gtk.gtk3.bookmarks =
        selfConfig.bookmarks
        ++ (lib.optionals selfConfig.addUserDirsToSidebar [
          "file://${config.home.homeDirectory}/Documents"
          "file://${config.home.homeDirectory}/Downloads"
          "file://${config.home.homeDirectory}/Music"
          "file://${config.home.homeDirectory}/Pictures"
          "file://${config.home.homeDirectory}/Videos"
        ]);
    };
}
