{
  config,
  osConfig,
  lib,
  ...
}: {
  options.zeide.graphical.hyprland.binds = with lib; {
    extra = mkOption {
      type = with types; listOf str;
      default = [];
      description = ''
        Extra binds.
      '';
    };
  };

  config = let
    cfg = config.zeide.graphical.hyprland.binds;

    workspaceDispatcher =
      if config.zeide.graphical.hyprland.plugins.hyprsplit.enable
      then "split:workspace"
      else "workspace";

    swapActiveWorkspacesDispatcher =
      if config.zeide.graphical.hyprland.plugins.hyprsplit.enable
      then "split:swapactiveworkspaces"
      else "swapactiveworkspaces";

    moveToWorkspaceSilentDispatcher =
      if config.zeide.graphical.hyprland.plugins.hyprsplit.enable
      then "split:movetoworkspacesilent"
      else "movetoworkspacesilent";
  in {
    wayland.windowManager.hyprland.settings = {
      bind =
        [
          "SUPER, V, togglefloating," # Toggle floating of the active window
          "SUPER, F, fullscreen," # Toggle fullscreen of the active window
          "SUPER, A, layoutmsg, togglesplit" # Toggle split direction of the active window
          "SUPER, C, killactive," # Close active window
          "SUPER SHIFT, M, exec, uwsm stop" # Force quit Hyprland

          "SUPER, left, movefocus, l" # Move focus left
          "SUPER, right, movefocus, r" # Move focus right
          "SUPER, up, movefocus, u" # Move focus up
          "SUPER, down, movefocus, d" # Move focus down

          "SUPER SHIFT, left, movewindow, l" # Move window to left
          "SUPER SHIFT, right, movewindow, r" # Move active window to right
          "SUPER SHIFT, up, movewindow, u" # Move active window up
          "SUPER SHIFT, down, movewindow, d" # Move active window down

          "SUPER mouse_down, ${workspaceDispatcher}, r+1" # Go to next workspace
          "SUPER, mouse_up, ${workspaceDispatcher}, r-1" # Go to previous workspace

          "SUPER, S, ${swapActiveWorkspacesDispatcher}, current+1" # Swap active workspaces

          "SUPER, L, exec, shiny-shell ipc call session lock"
          "SUPER, SPACE, exec, shiny-shell ipc call launcher toggle"
        ]
        ++ map (i: "SUPER, ${toString i}, ${workspaceDispatcher}, ${toString i}") [
          1
          2
          3
          4
          5
          6
          7
          8
          9
        ]
        ++ map (i: "SUPER SHIFT, ${toString i}, ${moveToWorkspaceSilentDispatcher}, ${toString i}") [
          1
          2
          3
          4
          5
          6
          7
          8
          9
        ]
        ++ [
          "SUPER, 0, ${workspaceDispatcher}, 10"
          "SUPER SHIFT, 0, ${moveToWorkspaceSilentDispatcher}, 10"
        ]
        ++ cfg.extra;

      bindm = [
        "SUPER, mouse:272, movewindow" # Move active window (left click)
        "SUPER, mouse:273, resizewindow" # Resize active window (right click)
      ];

      bindl = lib.optionals osConfig.zeide.audio.enable [
        ", XF86AudioMute, exec, shiny-shell ipc call audio toggleOutputMute"
        ", XF86AudioMicMute, exec, shiny-shell ipc call audio toggleInputMute"

        ", XF86AudioPlay, exec, shiny-shell ipc call player playPause"
        ", XF86AudioPause, exec, shiny-shell ipc call player playPause"
        ", XF86AudioNext, exec, shiny-shell ipc call player next"
        ", XF86AudioPrev, exec, shiny-shell ipc call player previous"
        ", XF86AudioStop, exec, shiny-shell ipc call player stop"
      ];

      bindel =
        lib.optionals osConfig.zeide.audio.enable [
          ", XF86AudioRaiseVolume, exec, shiny-shell ipc call audio outputVolume +4%"
          ", XF86AudioLowerVolume, exec, shiny-shell ipc call audio outputVolume -4%"
        ]
        ++ lib.optionals osConfig.zeide.laptop.enable [
          ", XF86MonBrightnessUp, exec, shiny-shell ipc call brightness set %default% +4%"
          ", XF86MonBrightnessDown, exec, shiny-shell ipc call brightness set %default% -4%"
        ];
    };
  };
}
