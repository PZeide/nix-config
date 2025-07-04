{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.services.librepods = with lib; {
    enable = mkEnableOption "librepods service";
    phoneMacAddress = mkOption {
      type = types.str;
      description = ''
        Bluetooth iPhone's MAC address, required for librepods to work.
      '';
    };
  };

  config = let
    selfConfig = config.zeide.services.librepods;
  in
    lib.mkIf selfConfig.enable {
      systemd.user.services.librepods = {
        Unit = {
          Description = "librepods";
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };

        Service = {
          Type = "simple";
          ExecStart = "${lib.getExe pkgs.zeide.librepods} --hide";
          Restart = "always";
          RestartSec = 1;
          TimeoutStopSec = 10;
          Environment = "PHONE_MAC_ADDRESS=${selfConfig.phoneMacAddress}";
        };

        Install.WantedBy = ["graphical-session.target"];
      };
    };
}
