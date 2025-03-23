{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.services.clipboard = with lib; {
    enable = mkEnableOption "clipboard utilities";
  };

  config = let
    selfConfig = config.zeide.services.clipboard;
  in
    lib.mkIf selfConfig.enable {
      home.packages = with pkgs; [wl-clipboard];

      systemd.user.services.wl-clip-persist = {
        Unit = {
          Description = "wl-clip-persist persistent clipboard";
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };

        Service = {
          Type = "simple";
          ExecStart = "${lib.getExe pkgs.wl-clip-persist} --clipboard regular";
          Restart = "always";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };

        Install.WantedBy = "graphical-session.target";
      };
    };
}
