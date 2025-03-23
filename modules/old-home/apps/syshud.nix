{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = [pkgs.syshud];

  xdg.configFile."sys64/hud/style.css".text = with config.lib.stylix.colors.withHashtag;
  with config.stylix.fonts; ''
    * {
      all: unset;
      font-family: ${sansSerif.name};
      font-size: ${toString sizes.applications}pt;
      color: ${base07};
      box-shadow: none;
    }

    #syshud {
    	background: transparent;
    }

    #syshud .box_layout {
    	background: ${base00}96;
    	border-radius: 15px;
    	margin: 15px;
      padding: 5px;
    }

    #syshud scale {}

    #syshud label {
      font-weight: bold;
    }

    /* Horizontal layout */
    #syshud scale.horizontal {
      margin: 0 10px;
    	padding: 0px;
    	min-height: 5px;
    }

    #syshud scale.horizontal trough {
    	border-radius: 3px;
    	background: alpha(currentColor, 0.1);
    	min-height: 5px;
    	padding: 0px;
    }

    #syshud scale.horizontal highlight {
    	border-radius: 3px;
    	min-height: 5px;
    	background: ${base07};
    	margin: 0px;
    }

    #syshud scale.horizontal slider {
    	margin: 0px;
    	background: transparent;
    	min-height: 5px;
    	padding: 0px;
    }

    /* Vertical layout */
    #syshud scale.vertical {
    	padding: 0px;
    	min-width: 5px;
    }

    #syshud scale.vertical trough {
    	border-radius: 3px;
    	background: alpha(currentColor, 0.1);
    	min-width: 5px;
    	padding: 0px;
    }

    #syshud scale.vertical highlight {
    	border-radius: 3px;
    	min-width: 5px;
    	background: ${base07};
    	margin: 0px;
    }

    #syshud scale.vertical slider {
    	margin: 0px;
    	background: transparent;
    	min-width: 5px;
    	padding: 0px;
    }

    #syshud image {
      color: @foreground;
    }

    /* Levels */
    #syshud .muted {}
    #syshud .low {}
    #syshud .medium {}
    #syshud .high {}
  '';

  systemd.user.services.syshud = {
    Install = {
      WantedBy = ["graphical-session.target"];
    };

    Unit = {
      ConditionEnvironment = "WAYLAND_DISPLAY";
      Description = "syshud";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
      X-Restart-Triggers = [
        "${config.xdg.configFile."sys64/hud/style.css".source}"
      ];
    };

    Service = {
      ExecStart = "${lib.getExe pkgs.syshud} -M audio_in,audio_out,brightness";
      Restart = "always";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
