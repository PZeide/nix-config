{
  config,
  lib,
  pkgs,
  ...
}: {
  services.greetd.settings = let
    session = {
      command = "${lib.getExe pkgs.uwsm} start hyprland-uwsm.desktop";
      user = config.system.core.defaultUser;
    };
  in {
    initial_session = session;
  };
}
