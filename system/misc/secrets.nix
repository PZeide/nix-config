{
  inputs,
  system,
  config,
  ...
}: let
  secret = file: ../../secrets/${file};
in {
  imports = [inputs.agenix.nixosModules.default];

  environment.systemPackages = [inputs.agenix.packages.${system}.default];

  age.secrets = {
    wakatime-key = {
      file = secret "wakatime-key.age";
      owner = config.system.core.defaultUser;
      group = "users";
    };
  };
}
