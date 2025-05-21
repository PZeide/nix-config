{
  config,
  lib,
  inputs,
  system,
  ...
}: {
  options.zeide.programs.gaming.osu-lazer = with lib; {
    enable = mkEnableOption "osu lazer";
  };

  config = let
    selfConfig = config.zeide.programs.gaming.osu-lazer;
  in
    lib.mkIf selfConfig.enable {
      home.packages = with inputs.nix-gaming.packages.${system}; [
        osu-lazer-bin
        osu-mime
      ];
    };
}
