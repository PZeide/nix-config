{
  asset,
  config,
  lib,
  ...
}: {
  options.zeide.services.easyeffects = with lib; {
    enable = mkEnableOption "easyeffects";
    enableDefaultPreset = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable a default preset which contains:
        - Noise Reduction + NPR Masculine Voice:
          https://gist.github.com/jtrv/47542c8be6345951802eebcf9dc7da31
      '';
    };
  };

  config = let
    selfConfig = config.zeide.services.easyeffects;
  in
    lib.mkIf selfConfig.enable {
      dconf.settings = {
        "com/github/wwmm/easyeffects" = {
          process-all-inputs = true;
          process-all-outputs = false; # Can cause xruns
        };
      };

      services.easyeffects = {
        enable = true;

        preset = lib.mkIf selfConfig.enableDefaultPreset "zeide-preset";

        extraPresets = {
          zeide-preset =
            lib.mkIf selfConfig.enableDefaultPreset
            (builtins.fromJSON (builtins.readFile (asset "easyeffects/zeide-preset.json")));
        };
      };
    };
}
