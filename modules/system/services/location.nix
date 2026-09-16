{
  config,
  lib,
  ...
}: {
  options.zeide.services.location = with lib; {
    enable = mkEnableOption "location access";
    submitGeoData = mkEnableOption "submitting geo data to provider";
  };

  config = let
    cfg = config.zeide.services.location;
  in
    lib.mkIf cfg.enable {
      location.provider = "geoclue2";

      services.geoclue2 = {
        enable = true;
        submitData = cfg.submitGeoData;
      };

      users.users.geoclue.extraGroups = ["networkmanager"];
    };
}
