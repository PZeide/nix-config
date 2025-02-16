{
  config,
  inputs,
  lib,
  ...
}: {
  home.packages = [inputs.ashell.defaultPackage.x86_64-linux];

  xdg.configFile."ashell.yml".text = ''

  '';

  systemd.user.services.ashell = {
    Install = {
      WantedBy = ["graphical-session.target"];
    };

    Unit = {
      ConditionEnvironment = "WAYLAND_DISPLAY";
      Description = "syshud";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
      X-Restart-Triggers = [
        "${config.xdg.configFile."sys64/hud/style.css".source}"
      ];
    };

    Service = {
      ExecStart = "${lib.getExe inputs.ashell.defaultPackage.x86_64-linux}";
      Restart = "always";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
