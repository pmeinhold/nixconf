# https://github.com/ryantm/agenix?tab=readme-ov-file#tutorial
let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4vpPLYf+6rzvDomLju8J+X7oOKxGNhN2C41sUx0b90";
  users = [ user1 ];
in
{
  "secret1.age".publicKeys = [ user1 ];
  "duckdns_token.age".publicKeys = [ user1 ];
}
