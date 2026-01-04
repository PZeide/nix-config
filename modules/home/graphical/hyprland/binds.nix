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
    selfConfig = config.zeide.graphical.hyprland.binds;

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
      "$mainMod" = "SUPER";

      bind =
        [
          "$mainMod, V, togglefloating," # Toggle floating of the active window
          "$mainMod, F, fullscreen," # Toggle fullscreen of the active window
          "$mainMod, A, togglesplit," # Toggle split direction of the active window
          "$mainMod, C, killactive," # Close active window
          "$mainMod SHIFT, M, exec, uwsm stop" # Force quit Hyprland

          "$mainMod, left, movefocus, l" # Move focus left
          "$mainMod, right, movefocus, r" # Move focus right
          "$mainMod, up, movefocus, u" # Move focus up
          "$mainMod, down, movefocus, d" # Move focus down

          "$mainMod SHIFT, left, movewindow, l" # Move window to left
          "$mainMod SHIFT, right, movewindow, r" # Move active window to right
          "$mainMod SHIFT, up, movewindow, u" # Move active window up
          "$mainMod SHIFT, down, movewindow, d" # Move active window down

          "$mainMod, mouse_down, ${workspaceDispatcher}, r+1" # Go to next workspace
          "$mainMod, mouse_up, ${workspaceDispatcher}, r-1" # Go to previous workspace

          "$mainMod, S, ${swapActiveWorkspacesDispatcher}, current+1" # Swap active workspaces

          # Shiny-shell
          "$mainMod, L, global, shiny-shell:session-lock"
          "$mainMod, M, global, shiny-shell:session-control-toggle"
          "$mainMod, TAB, global, shiny-shell:overview-toggle"
          "$mainMod, SPACE, global, shiny-shell:launcher-toggle"
        ]
        ++ map (i: "$mainMod, ${toString i}, ${workspaceDispatcher}, ${toString i}") [
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
        ++ map (i: "$mainMod SHIFT, ${toString i}, ${moveToWorkspaceSilentDispatcher}, ${toString i}") [
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
          "$mainMod, 0, ${workspaceDispatcher}, 10"
          "$mainMod SHIFT, 0, ${moveToWorkspaceSilentDispatcher}, 10"
        ]
        ++ selfConfig.extra;

      bindm = [
        "$mainMod, mouse:272, movewindow" # Move active window (left click)
        "$mainMod, mouse:273, resizewindow" # Resize active window (right click)
      ];

      bindl = lib.optionals osConfig.zeide.audio.enable [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        ", XF86AudioPlay, global, shiny-shell:player-play-pause"
        ", XF86AudioPause, global, shiny-shell:player-playpause"
        ", XF86AudioNext, global, shiny-shell:player-next"
        ", XF86AudioPrev, global, shiny-shell:player-previous"
        ", XF86AudioStop, global, shiny-shell:player-stop"
      ];

      bindel =
        lib.optionals osConfig.zeide.audio.enable [
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 4%-"
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 4%+"
        ]
        ++ lib.optionals osConfig.zeide.laptop.enable [
          ", XF86MonBrightnessUp, global, shiny-shell:brightness-increment"
          ", XF86MonBrightnessDown, global, shiny-shell:brightness-decrement"
        ];
    };
  };
}
