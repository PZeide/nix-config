{
  config,
  inputs,
  ...
}: {
  home.packages = [inputs.ashell.defaultPackage.x86_64-linux];

  xdg.configFile."ashell.yml".text = ''
    position: Top
    modules:
      left:
        - Workspaces

      center:
        - WindowTitle

      right:
        - SystemInfo
        - Tray
        - MediaPlayer
        - [Clock, Privacy, Settings]

    workspaces:
      visibilityMode: MonitorSpecific

    settings:
      lockCmd: "loginctl lock-session"
      wifiMoreCmd: "uwsm app -- nm-connection-editor"
      vpnMoreCmd: "uwsm app -- protonvpn-app"
      bluetoothMoreCmd: "uwsm app -- overskride"
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
        "${config.xdg.configFile."ashell.yml".source}"
      ];
    };

    Service = {
      ExecStart = "${inputs.ashell.defaultPackage.x86_64-linux}/bin/ashell";
      Restart = "always";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
