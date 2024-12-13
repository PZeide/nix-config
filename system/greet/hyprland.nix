{
  config,
  lib,
  ...
}:

{
  services.greetd.settings =
    let
      session = {
        command = "${lib.getExe config.programs.hyprland.package}";
        user = "${config.main.core.defaultUser}";
      };
    in
    {
      initial_session = session;
    };
}
