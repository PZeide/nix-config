{config, ...}: let
  cfg = config.home.hyprland;
in {
  wayland.windowManager.hyprland.settings = {
    monitor = cfg.monitors ++ [", highres, auto, 1"];

    general = {
      border_size = 3;
      gaps_in = 6;
      gaps_out = 18;

      layout = "dwindle";
      resize_on_border = true;

      # Allow tearing for apps (usually games) with 'immediate' rule applied to them
      allow_tearing = true;
    };

    decoration = {
      rounding = 20;

      shadow = {
        enabled = true;
        ignore_window = true;
        range = 20;
        offset = "0 2";
        render_power = 2;
      };

      blur = {
        enabled = true;
        size = 4;
        passes = 2;
        new_optimizations = true;
        contrast = 1;
        popups = true;
        popups_ignorealpha = 0.8;
      };

      active_opacity = 0.9;
      inactive_opacity = 0.8;
      fullscreen_opacity = 1;
    };

    animations = {
      first_launch_animation = false;
      enabled = true;

      # Animation curves
      bezier = [
        "linear, 0, 0, 1, 1"
        "md3_standard, 0.2, 0, 0, 1"
        "md3_decel, 0.05, 0.7, 0.1, 1"
        "md3_accel, 0.3, 0, 0.8, 0.15"
        "overshot, 0.05, 0.9, 0.1, 1.1"
        "crazyshot, 0.1, 1.5, 0.76, 0.92"
        "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
        "menu_decel, 0.1, 1, 0, 1"
        "menu_accel, 0.38, 0.04, 1, 0.07"
        "easeInOutCirc, 0.85, 0, 0.15, 1"
        "easeOutCirc, 0, 0.55, 0.45, 1"
        "easeOutExpo, 0.16, 1, 0.3, 1"
        "softAcDecel, 0.26, 0.26, 0.15, 1"
      ];

      # Animation configs
      animation = [
        "windows, 1, 3, md3_decel, popin 60%"
        "windowsIn, 1, 3, md3_decel, popin 60%"
        "windowsOut, 1, 3, md3_accel, popin 60%"
        "border, 1, 10, default"
        "fade, 1, 3, md3_decel"
        "layersIn, 1, 3, menu_decel, slide"
        "layersOut, 1, 1.6, menu_accel"
        "workspaces, 1, 7, menu_decel, slide"
        "specialWorkspace, 1, 3, md3_decel, slidevert"
      ];
    };

    input = {
      kb_layout = "us";
      kb_variant = "intl";

      numlock_by_default = true;
      sensitivity = -0.3;
      accel_profile = "flat";
      follow_mouse = 1;
      special_fallthrough = true;

      touchpad = {
        disable_while_typing = true;
        natural_scroll = true;
        clickfinger_behavior = true;
        scroll_factor = 0.6;
      };
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_distance = 400;
      workspace_swipe_cancel_ratio = 0.2;
      workspace_swipe_min_speed_to_force = 5;
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;

      font_family = "SF Pro Display";
      new_window_takes_over_fullscreen = true;
      focus_on_activate = true;

      vfr = 1;
      vrr = 2;
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    xwayland = {
      force_zero_scaling = true;
    };

    render = {
      direct_scanout = true;
    };

    ecosystem = {
      no_update_news = true;
      no_donation_nag = true;
    };
  };
}
