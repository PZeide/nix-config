{
  inputs,
  system,
  ...
}: {
  wayland.windowManager.hyprland = {
    plugins = [
      inputs.hyprland-plugins.packages.${system}.hyprexpo
      inputs.hyprsplit.packages.${system}.hyprsplit
    ];

    settings.plugin = {
      hyprsplit = {
        num_workspaces = 9;
        persistent_workspaces = true;
      };

      hyprexpo = {
        columns = 3;
        gap_size = 4;
        bg_col = "rgb(000000)";

        enable_gesture = true;
        gesture_distance = 300;
        gesture_positive = false;
      };
    };
  };
}
