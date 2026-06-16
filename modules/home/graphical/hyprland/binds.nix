{
  config,
  osConfig,
  lib,
  ...
}: {
  options.zeide.graphical.hyprland.binds = with lib; {
    extra = mkOption {
      type = with types; listOf attrs;
      default = [];
      description = ''
        Extra binds.
      '';
    };
  };

  config = let
    cfg = config.zeide.graphical.hyprland.binds;

    mkLua = lib.generators.mkLuaInline;

    exec = command: ''hl.dsp.exec_cmd(${builtins.toJSON command})'';

    bind = key: dispatcher: {
      _args = [
        key
        (mkLua dispatcher)
      ];
    };

    bindWith = opts: key: dispatcher: {
      _args = [
        key
        (mkLua dispatcher)
        opts
      ];
    };

    workspace = target:
      if config.zeide.graphical.hyprland.plugins.hyprsplit.enable
      then ''hs.dsp.focus({ workspace = ${builtins.toJSON target} })''
      else ''hl.dsp.focus({ workspace = ${builtins.toJSON target} })'';

    moveToWorkspaceSilent = target:
      if config.zeide.graphical.hyprland.plugins.hyprsplit.enable
      then ''hs.dsp.window.move({ workspace = ${builtins.toJSON target}, follow = false })''
      else ''hl.dsp.window.move({ workspace = ${builtins.toJSON target}, follow = false })'';

    swapActiveWorkspaces =
      if config.zeide.graphical.hyprland.plugins.hyprsplit.enable
      then ''hs.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "+1" })''
      else exec "hyprctl dispatch swapactiveworkspaces current+1";
  in {
    wayland.windowManager.hyprland.settings = {
      bind =
        [
          (bind "SUPER + V" ''hl.dsp.window.float({ action = "toggle" })'')
          (bind "SUPER + F" "hl.dsp.window.fullscreen()")
          (bind "SUPER + A" ''hl.dsp.layout("togglesplit")'')
          (bind "SUPER + C" "hl.dsp.window.close()")
          (bind "SUPER + SHIFT + M" (exec "uwsm stop"))

          (bind "SUPER + left" ''hl.dsp.focus({ direction = "left" })'')
          (bind "SUPER + right" ''hl.dsp.focus({ direction = "right" })'')
          (bind "SUPER + up" ''hl.dsp.focus({ direction = "up" })'')
          (bind "SUPER + down" ''hl.dsp.focus({ direction = "down" })'')

          (bind "SUPER + SHIFT + left" ''hl.dsp.window.move({ direction = "left" })'')
          (bind "SUPER + SHIFT + right" ''hl.dsp.window.move({ direction = "right" })'')
          (bind "SUPER + SHIFT + up" ''hl.dsp.window.move({ direction = "up" })'')
          (bind "SUPER + SHIFT + down" ''hl.dsp.window.move({ direction = "down" })'')

          (bind "SUPER + mouse_down" (workspace "r+1"))
          (bind "SUPER + mouse_up" (workspace "r-1"))

          (bind "SUPER + S" swapActiveWorkspaces)

          (bind "SUPER + L" (exec "shiny-shell ipc call session lock"))
          (bind "SUPER + SPACE" (exec "shiny-shell ipc call launcher toggle"))
        ]
        ++ map (i: bind "SUPER + ${toString i}" (workspace (toString i))) [1 2 3 4 5 6 7 8 9]
        ++ map (i: bind "SUPER + SHIFT + ${toString i}" (moveToWorkspaceSilent (toString i))) [1 2 3 4 5 6 7 8 9]
        ++ [
          (bind "SUPER + 0" (workspace "10"))
          (bind "SUPER + SHIFT + 0" (moveToWorkspaceSilent "10"))
        ]
        ++ cfg.extra
        ++ [
          (bindWith {mouse = true;} "SUPER + mouse:272" "hl.dsp.window.drag()")
          (bindWith {mouse = true;} "SUPER + mouse:273" "hl.dsp.window.resize()")
        ]
        ++ lib.optionals osConfig.zeide.audio.enable [
          (bindWith {locked = true;} "XF86AudioMute" (exec "shiny-shell ipc call audio toggleOutputMute"))
          (bindWith {locked = true;} "XF86AudioMicMute" (exec "shiny-shell ipc call audio toggleInputMute"))

          (bindWith {locked = true;} "XF86AudioPlay" (exec "shiny-shell ipc call player playPause"))
          (bindWith {locked = true;} "XF86AudioPause" (exec "shiny-shell ipc call player playPause"))
          (bindWith {locked = true;} "XF86AudioNext" (exec "shiny-shell ipc call player next"))
          (bindWith {locked = true;} "XF86AudioPrev" (exec "shiny-shell ipc call player previous"))
          (bindWith {locked = true;} "XF86AudioStop" (exec "shiny-shell ipc call player stop"))
        ]
        ++ lib.optionals osConfig.zeide.audio.enable [
          (bindWith {
            locked = true;
            repeating = true;
          } "XF86AudioRaiseVolume" (exec "shiny-shell ipc call audio outputVolume +4%"))
          (bindWith {
            locked = true;
            repeating = true;
          } "XF86AudioLowerVolume" (exec "shiny-shell ipc call audio outputVolume -4%"))
        ]
        ++ lib.optionals osConfig.zeide.laptop.enable [
          (bindWith {
            locked = true;
            repeating = true;
          } "XF86MonBrightnessUp" (exec "shiny-shell ipc call brightness set %default% +4%"))
          (bindWith {
            locked = true;
            repeating = true;
          } "XF86MonBrightnessDown" (exec "shiny-shell ipc call brightness set %default% -4%"))
        ];
    };
  };
}
