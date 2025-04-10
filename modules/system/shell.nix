{
  config,
  lib,
  ...
}: {
  options.zeide.shell = with lib; {
    fishIntegration = mkEnableOption "fish shell integration, required alongside home configuration for completions";
  };

  config = let
    selfConfig = config.zeide.shell;
  in {
    # Enable vendor completions provided by nixpkgs
    programs.fish.enable = lib.mkIf selfConfig.fishIntegration true;
  };
}
