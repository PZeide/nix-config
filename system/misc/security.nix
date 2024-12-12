{ pkgs, ... }:

{
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    polkit_gnome
  ];

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "always";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  services.gnome.gnome-keyring.enable = true;
  services.dbus.packages = [ pkgs.gcr ];

  security.pam.services = {
    # TODO FIX HYPRLOCK GKR
    #login.enableGnomeKeyring = true;
    hyprlock.enableGnomeKeyring = true;
  };
}
