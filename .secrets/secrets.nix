let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHCDjJUPndCiqZIfXtt2y33ClwsTcsf0EhQo7+AjjVAB";
  users = [ user1 ];
  # system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJDyIr/FSz1cJdcoW69R+NrWzwGK/+3gJpqD1t8L2zE";
  # systems = [ system1 ];
in
{
  "secret1.age".publicKeys = [ user1 ];
}
