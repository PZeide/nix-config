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
    cfg = config.zeide.programs.gaming.osu-lazer;
  in
    lib.mkIf cfg.enable {
      home.packages = with inputs.nix-gaming.packages.${system}; [
        osu-lazer-bin
        osu-mime
      ];
    };
}
