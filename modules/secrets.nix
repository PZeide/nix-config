{
  system,
  config,
  inputs,
  ...
}: {
  imports = [inputs.agenix.nixosModules.default];

  environment.systemPackages = [inputs.agenix.packages.${system}.default];

  age.secrets = let
    secret = file: ../secrets/${file};
  in {
    wakatime-key = {
      file = secret "wakatime-key.age";
      owner = config.zeide.user;
      group = "users";
    };
  };
}
