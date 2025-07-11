{
  config,
  lib,
  inputs,
  system,
  ...
}: {
  options.zeide.programs.anyrun = with lib; {
    enable = mkEnableOption "anyrun application launcher";

    preprocessScript = mkOption {
      type = types.str;
      default = "";
      description = ''
        Script to execute before launching an app
      '';
    };
  };

  config = let
    selfConfig = config.zeide.programs.anyrun;
  in
    lib.mkIf selfConfig.enable {
      programs.anyrun = {
        enable = true;
        package = inputs.anyrun.packages.${system}.anyrun;

        config = {
          plugins = with inputs.anyrun.packages.${system}; [
            applications
            randr
            rink
            shell
          ];

          width.fraction = 0.25;
          y.fraction = 0.3;
          hidePluginInfo = true;
          closeOnClick = true;
        };

        extraCss = ''
          * {
            all: unset;
            font-size: 1.2rem;
          }

          #window,
          #match,
          #entry,
          #plugin,
          #main {
            background: transparent;
          }

          #match.activatable {
            border-radius: 8px;
            margin: 4px 0;
            padding: 4px;
            /* transition: 100ms ease-out; */
          }
          #match.activatable:first-child {
            margin-top: 12px;
          }
          #match.activatable:last-child {
            margin-bottom: 0;
          }

          #match:hover {
            background: rgba(255, 255, 255, 0.05);
          }
          #match:selected {
            background: rgba(255, 255, 255, 0.1);
          }

          #entry {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            padding: 4px 8px;
          }

          box#main {
            background: rgba(0, 0, 0, 0.5);
            box-shadow:
              inset 0 0 0 1px rgba(255, 255, 255, 0.1),
              0 30px 30px 15px rgba(0, 0, 0, 0.5);
            border-radius: 20px;
            padding: 12px;
          }
        '';

        extraConfigFiles = {
          "applications.ron".text = ''
            Config(
              desktop_actions: true,
              max_entries: 5,
              preprocess_exec_script: Some("${selfConfig.preprocessScript}")
            )
          '';

          "shell.ron".text = ''
            Config(
              prefix: Some(">")
            )
          '';

          "randr.ron".text = ''
            Config(
              prefix: Some(":dp"),
              max_entries: 5,
            )
          '';
        };
      };
    };
}
