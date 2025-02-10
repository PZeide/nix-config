{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mangohud
    bottles
  ];

  programs = {
    steam.enable = true;

    gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          renice = 10;
        };
      };
    };

    gamescope = {
      enable = true;
      args = [];
      capSysNice = true;
    };
  };
}
