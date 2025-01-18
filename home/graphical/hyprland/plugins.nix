{
  inputs,
  system,
  ...
}:

{
  wayland.windowManager.hyprland = {
    plugins = [
      inputs.hyprland-plugins.packages.${system}.hyprexpo
      inputs.hyprsplit.packages.${system}.hyprsplit
    ];

    settings.plugin = {
      hyprsplit = {
        num_workspaces = 9;
      };

      hyprexpo = {
        columns = 3;
        gap_size = 5;
        bg_col = "rgb(111111)";
        workspace_method = "center current";

        enable_gesture = true;
        gesture_fingers = 3;
        gesture_distance = 300;
        gesture_positive = true;
      };
    };
  };
}
