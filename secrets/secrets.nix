let
  # Systems
  poppy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILhJ0QdHoDe0agOMZwpF6uEn3LwEUeYFGAAh50fptosL";
  caveserver = "";

  # Users (for acccess)
  nullcube = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ8qUgVoBKq5DdokVxzqQmIbrpkvp09s8o3PjAO3HuLr";

  keys = [
    # Systems
    poppy

    # Users (for access)
    nullcube
  ];
in
{
  "bryan-pass.age".publicKeys = keys;
  "cf-dns-token.age".publicKeys = keys;
  "nullcube-pass.age".publicKeys = keys;
  "ravenshade-pass.age".publicKeys = keys;
}
