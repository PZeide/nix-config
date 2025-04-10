{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    wl-clipboard
    wl-clip-persist
  ];

  systemd.user.services.wl-clip-persist = {
    Install = {
      WantedBy = ["graphical-session.target"];
    };

    Unit = {
      Description = "wl-clip-persist";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${lib.getExe pkgs.wl-clip-persist} --clipboard regular";
      Restart = "always";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
