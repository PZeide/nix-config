{
  config,
  lib,
  ...
}: {
  options.zeide.shell = with lib; {
    enable = mkEnableOption "shell config with fish, required alongside home configuration for completions";
  };

  config = let
    selfConfig = config.zeide.shell;
  in
    lib.mkIf selfConfig.enable {
      # Enable vendor completions provided by nixpkgs
      programs.fish.enable = true;
    };
}
