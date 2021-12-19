let
  peteresselius = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFlSpVaRmOA/4++oNbSW+kt2TgDmwX6O7ft126Rlmef";
  users = [ peteresselius ];

  vagrant = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH26z/Iv6sF/JezX2KC1VrL3nBxhAE5FEANi9Q0dCeVA";
  systems = [ vagrant ];
in
{
  "github_token.age".publicKeys = users ++ systems;
}
