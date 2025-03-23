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
    selfConfig = config.zeide.services.location;
  in
    lib.mkIf selfConfig.enable {
      location.provider = "geoclue2";

      services.geoclue2 = {
        enable = true;

        geoProviderUrl = "https://beacondb.net/v1/geolocate";
        submissionUrl = "https://beacondb.net/v2/geosubmit";
        submissionNick = "geoclue";
        submitData = selfConfig.submitGeoData;
      };
    };
}
