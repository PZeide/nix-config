let
  nilou = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3EcOQKuyVZE+Tp2HNKTMnqbZAxbSaAccEcfrN/L2Im";
  jane = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK+HUnFTVSZfQCJRBKKouK6pH0z/+rSPYsL7YdAUCvY4";

  all = [
    nilou
    jane
  ];
in {
  "wakatime-key.age".publicKeys = all;
}
