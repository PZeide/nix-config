{ config, pkgs, ... }:

{
  services.greetd = {
    enable = true;
    vt = 1;

    settings = {
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd $SHELL";
        user = "${config.main.core.defaultUser}";
      };
    };
  };
}
