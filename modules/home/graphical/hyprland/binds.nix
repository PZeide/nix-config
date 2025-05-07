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

    # FIXME https://github.com/hyprwm/hyprland-plugins/issues/119
    hyprExpoFix = ''
      exec, if [ "$(hyprctl activewindow -j | jq '.fullscreen')" != "0" ]; then hyprctl dispatch fullscreen; fi ; hyprctl dispatch hyprexpo:expo toggle
    '';
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

          "$mainMod, L, exec, loginctl lock-session" # Lock
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
        ++ lib.optional config.zeide.graphical.hyprland.plugins.hyprexpo.enable "$mainMod, Tab, ${hyprExpoFix}"
        ++ selfConfig.extra;

      bindm = [
        "$mainMod, mouse:272, movewindow" # Move active window (left click)
        "$mainMod, mouse:273, resizewindow" # Resize active window (right click)
      ];

      bindl = lib.optionals osConfig.zeide.audio.enable [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioStop, exec, playerctl stop"
      ];

      bindel =
        lib.optionals osConfig.zeide.audio.enable [
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 2%+"
        ]
        ++ lib.optionals osConfig.zeide.laptop.enable [
          ", XF86MonBrightnessUp, exec, brillo -u 100000 -A 2"
          ", XF86MonBrightnessDown, exec, brillo -u 100000 -U 2"
        ];
    };
  };
}
