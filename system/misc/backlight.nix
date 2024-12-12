{ config, ... }:

{
  hardware.brillo.enable = true;

  users.users."${config.main.core.defaultUser}" = {
    extraGroups = [ "video" ];
  };
}
