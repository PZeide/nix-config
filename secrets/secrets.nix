let
  nilou = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGZ43VQYKtiUyfU9WJFwaC6j0Qccq9c6/Nq7T1xVuVxY zeide.thibaud@gmail.com";
  jane = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICDmHseZIBShn77TArDMexkhqzzgBoB0UgNPHtuh5WSN zeide.thibaud@gmail.com";

  all = [
    nilou
    jane
  ];
in
{
  "wakatime-key.age".publicKeys = all;
}
