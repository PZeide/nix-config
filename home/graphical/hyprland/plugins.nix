{
  inputs,
  system,
  ...
}:

{
  wayland.windowManager.hyprland = {
    plugins = [
      inputs.hyprspace.packages.${system}.Hyprspace
      inputs.hyprsplit.packages.${system}.hyprsplit
    ];

    settings.plugin = {
      hyprsplit = {
        num_workspaces = 9;
      };

      overview = {
        dragAlpha = 0.6;
        autoDrag = true;
        autoScroll = true;
        exitOnClick = true;
        exitOnSwitch = true;
      };
    };
  };
}
