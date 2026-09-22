# https://github.com/ryantm/agenix?tab=readme-ov-file#tutorial
let
  # User pub keys
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4vpPLYf+6rzvDomLju8J+X7oOKxGNhN2C41sUx0b90";
  paulm_vps0 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILhD78ei6qNjHPMEuSC49dlXZgUXH7b1884VP7tM7pxo paulm@vps0";
  users = [ paulm_vps0 default ];

  # System pub keys
  srvr = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE6MUaxloE+8Vxj9bZ5MvFJXtuDlqST5HqwD5q+7VfMc root@nixos";
  vps0 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK6yGBaKtk/t7X3B8a6krU2/1xnzzA8eWjFrbWaceEHx root@vps0";
  systems = [ vps0 srvr ];
in
{
  # "secret1.age".publicKeys = [ user1 ];
  "duckdns_token.age".publicKeys = [ srvr ];
  "syncthing_gui_pw.age".publicKeys = [ default ];
  "obsidian_remote_password.age".publicKeys = [ vps0 ];
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
