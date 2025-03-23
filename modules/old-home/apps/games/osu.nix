{
  inputs,
  system,
  ...
}: {
  home.packages = [
    inputs.nix-gaming.packages.${system}.osu-lazer-bin
  ];
}
