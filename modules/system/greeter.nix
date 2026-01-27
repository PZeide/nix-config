{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.greeter = with lib; {
    enable = mkEnableOption "greeter service";

    initialSessionCommand = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        Command to run as an initial session.
        Initial session will skip login prompt and will automatically run the command as the user.
      '';
    };
  };

  config = let
    cfg = config.zeide.greeter;
  in
    lib.mkIf cfg.enable {
      services.greetd = {
        enable = true;

        settings = {
          default_session = {
            command = "${pkgs.greetd}/bin/agreety --cmd $SHELL";
            user = config.zeide.user;
          };

          initial_session = lib.mkIf (cfg.initialSessionCommand != null) {
            command = cfg.initialSessionCommand;
            user = config.zeide.user;
          };
        };
      };
    };
}
