# https://github.com/ryantm/agenix?tab=readme-ov-file#tutorial
let
  # User pub keys
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4vpPLYf+6rzvDomLju8J+X7oOKxGNhN2C41sUx0b90";
  users = [ default ];

  # System pub keys
  srvr = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE6MUaxloE+8Vxj9bZ5MvFJXtuDlqST5HqwD5q+7VfMc root@nixos";
  systems = [ srvr ];
in
{
  # "secret1.age".publicKeys = [ user1 ];
  "duckdns_token.age".publicKeys = [ srvr ];
  "syncthing_gui_pw.age".publicKeys = [ default ];
}

# Usage:
#   cd secrets/
#   agenix -e <secret>.age
#
# Then reference it like this:
#   age.secrets.nextcloud = {
#     file = ./secrets/secret1.age;
#     owner = "nextcloud";
#     group = "nextcloud";
#   };
#   services.nextcloud = {
#     enable = true;
#     package = pkgs.nextcloud28;
#     hostName = "localhost";
#     config.adminpassFile = config.age.secrets.nextcloud.path;
#   };
# https://wiki.nixos.org/wiki/Agenix
