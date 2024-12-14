{
  inputs,
  system,
  config,
  ...
}:

let
  secret = file: ../../secrets/${file};
in
{
  imports = [ inputs.agenix.nixosModules.default ];

  environment.systemPackages = [ inputs.agenix.packages.${system}.default ];

  age = {
    secrets = {
      wakatime-key = {
        file = secret "wakatime-key.age";
        owner = config.main.core.defaultUser;
        group = "users";
      };
    };

    identityPaths = [
      "/home/${config.main.core.defaultUser}/.ssh/id_rsa"
      "/home/${config.main.core.defaultUser}/.ssh/id_ed25519"
    ];
  };
}
