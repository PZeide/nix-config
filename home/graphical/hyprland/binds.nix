{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.home.hyprland;

  wrapUwsm = app: "uwsm app -- ${app}";
in
{
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    bind =
      [
        "$mainMod, V, togglefloating," # Toggle floating of the active window
        "$mainMod, F, fullscreen," # Toggle fullscreen of the active window
        "$mainMod, A, togglesplit," # Toggle split direction of the active window
        "$mainMod, C, killactive," # Close active window
        "$mainMod SHIFT, M, exit," # Force quit Hyprland

        "$mainMod, left, movefocus, l" # Move focus left
        "$mainMod, right, movefocus, r" # Move focus right
        "$mainMod, up, movefocus, u" # Move focus up
        "$mainMod, down, movefocus, d" # Move focus down

        "$mainMod SHIFT, left, movewindow, l" # Move window to left
        "$mainMod SHIFT, right, movewindow, r" # Move active window to right
        "$mainMod SHIFT, up, movewindow, u" # Move active window up
        "$mainMod SHIFT, down, movewindow, d" # Move active window down

        "$mainMod, Tab, overview:toggle," # Show workspaces overview

        "$mainMod, mouse_down, split:workspace, r+1" # Go to next workspace
        "$mainMod, mouse_up, split:workspace, r-1" # Go to previous workspace

        "$mainMod, S, split:swapactiveworkspaces, current+1" # Swap active workspaces

        "$mainMod, L, exec, loginctl lock-session" # Lock

        "$mainMod, SPACE, exec, ${wrapUwsm "walker"}"
        "$mainMod, Q, exec, ${wrapUwsm "kitty"}" # Terminal
        "$mainMod, E, exec, ${wrapUwsm "nautilus"}" # File explorer
        "$mainMod, B, exec, ${wrapUwsm "zen"}" # Browser
      ]
      ++ map (i: "$mainMod, ${toString i}, split:workspace, ${toString i}") [
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
      ++ map (i: "$mainMod SHIFT, ${toString i}, split:movetoworkspacesilent, ${toString i}") [
        1
        2
        3
        4
        5
        6
        7
        8
        9
      ];

    bindm = [
      "$mainMod, mouse:272, movewindow" # Move active window (left click)
      "$mainMod, mouse:273, resizewindow" # Resize active window (right click)
    ];

    bindl = [
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioStop, exec, playerctl stop"
    ];

    bindel =
      [
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 2%+"
      ]
      ++ lib.optionals (cfg.backlightBinds) [
        ", XF86MonBrightnessUp, exec, brillo -u 100000 -A 2"
        ", XF86MonBrightnessDown, exec, brillo -u 100000 -U 2"
      ];
  };
}
