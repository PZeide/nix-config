{ config, ... }:

{
  networking.networkmanager.enable = true;

  users.users."${config.main.core.defaultUser}" = {
    extraGroups = [ "networkmanager" ];
  };
}
