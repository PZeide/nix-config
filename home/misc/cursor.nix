{
  inputs,
  system,
  pkgs,
  ...
}:

{
  home = {
    packages = [
      inputs.rose-pine-hyprcursor.packages.${system}.default
    ];

    sessionVariables = {
      HYPRCURSOR_THEME = "rose-pine-hyprcursor";
      HYPRCURSOR_SIZE = 24;
    };
  };

  stylix.cursor = {
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
    size = 24;
  };
}
