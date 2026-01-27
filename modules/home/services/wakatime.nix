{
  config,
  secrets,
  lib,
  ...
}: {
  options.zeide.services.wakatime = with lib; {
    enable = mkEnableOption "wakatime key provider";
  };

  config = let
    cfg = config.zeide.services.wakatime;
  in
    lib.mkIf cfg.enable {
      home.file.".wakatime.cfg".text = ''
        [settings]
        api_key_vault_cmd="cat ${secrets.wakatime-key.path}"
      '';
    };
}
