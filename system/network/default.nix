{config, ...}: {
  networking.networkmanager.enable = true;

  users.users.${config.system.core.defaultUser} = {
    extraGroups = ["networkmanager"];
  };
}
