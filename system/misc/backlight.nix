{config, ...}: {
  hardware.brillo.enable = true;

  users.users.${config.system.core.defaultUser} = {
    extraGroups = ["video"];
  };
}
