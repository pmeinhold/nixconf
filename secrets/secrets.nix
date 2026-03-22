# https://github.com/ryantm/agenix?tab=readme-ov-file#tutorial
let
  # user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4vpPLYf+6rzvDomLju8J+X7oOKxGNhN2C41sUx0b90";
  srvr = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE6MUaxloE+8Vxj9bZ5MvFJXtuDlqST5HqwD5q+7VfMc root@nixos";
in
{
  # "secret1.age".publicKeys = [ user1 ];
  "duckdns_token.age".publicKeys = [ srvr ];
}
