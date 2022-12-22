let
  pavilion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMN0RUpcwLXYxO95cCrD4wRBexq2O6o41/3rOtOMvI3K";
  hosts = [ pavilion ];
  samn = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOVzwZ8jPX0N1cmc7K7t9R2wyX4SBFr8fik/eRVHnwmf";
  users = [ samn ];
in
{
  "secrets/passwords/users/samn.age".publicKeys = hosts ++ users;
  "secrets/networks.age".publicKeys = hosts ++ users;
  "secrets/wireguard/pavilion.key.age".publicKeys = [ pavilion ] ++ users;
}
