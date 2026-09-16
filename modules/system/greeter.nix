{
  config,
  lib,
  inputs,
  system,
  ...
}: {
  options.zeide.greeter = with lib; {
    enable = mkEnableOption "greeter service";

    user = mkOption {
      type = types.str;
      default = "thibaud";
      description = ''
        User to run the greeter as.
      '';
    };

    session = mkOption {
      type = types.str;
      default = "hyprland";
      description = ''
        Session entry to use for the greeter.
      '';
    };
  };

  imports = [inputs.shiny-shell.nixosModules.greeter];

  config = let
    cfg = config.zeide.greeter;
  in
    lib.mkIf cfg.enable {
      programs.shiny-shell-greeter = {
        enable = true;
        hyprlandPackage = inputs.hyprland.packages.${system}.hyprland;
        user = cfg.user;
        session = cfg.session;
        settings = config.home-manager.users.${cfg.user}.programs.shiny-shell.settings;
        hyprlandSettings = let
          hmHyprlandSettings = config.home-manager.users.${cfg.user}.wayland.windowManager.hyprland.settings;
        in {
          monitor = hmHyprlandSettings.monitor;
          input = hmHyprlandSettings.config.input;
          device = hmHyprlandSettings.device;
        };
      };
    };
}
