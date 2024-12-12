{
  config,
  pkgs,
  inputs,
  lib,
  system,
  ...
}:

let
  cfg = config.home.hyprland;

  hyprctl = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl";
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
  playerctl = "${lib.getExe pkgs.playerctl}";
  brillo = "${lib.getExe pkgs.brillo}";
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

        "$mainMod, SPACE, exec, ${lib.getExe inputs.walker.packages.${system}.default}"
        "$mainMod, Q, exec, ${lib.getExe pkgs.kitty}" # Terminal
        "$mainMod, E, exec, ${lib.getExe pkgs.nautilus}" # File explorer
        "$mainMod, B, exec, zen" # Browser
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
      ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

      ", XF86AudioPlay, exec, ${playerctl} play-pause"
      ", XF86AudioPlay, exec, ${playerctl} play-pause"
      ", XF86AudioNext, exec, ${playerctl} next"
      ", XF86AudioPrev, exec, ${playerctl} previous"
      ", XF86AudioStop, exec, ${playerctl} stop"
    ];

    bindel =
      [
        ", XF86AudioLowerVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 2%-"
        ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 2%+"
      ]
      ++ lib.optionals (cfg.backlightBinds) [
        ", XF86MonBrightnessUp, exec, ${brillo} -u 100 -A 2"
        ", XF86MonBrightnessDown, exec, ${brillo} -u 100 -U 2"
      ];
  };
}
