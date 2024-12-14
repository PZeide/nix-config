let
  nilou = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3EcOQKuyVZE+Tp2HNKTMnqbZAxbSaAccEcfrN/L2Im";
  jane = "";

  all = [
    nilou
    jane
  ];
in
{
  "wakatime-key.age".publicKeys = all;
}
