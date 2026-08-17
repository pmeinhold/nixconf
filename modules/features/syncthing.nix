{ config, inputs, ... }:
let
  flakeConfig = config;
  defaultUser = "paulm";
in
{
  flake.modules.nixos.feature-syncthing = { config, pkgs, ... }:
  {

    age.identityPaths = [ "/home/${defaultUser}/.ssh/id_ed25519" ];
    age.secrets.syncthing = {
      file = ../../secrets/syncthing_gui_pw.age;
      owner = "${defaultUser}";
    };

    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = "${defaultUser}"; # breaks if group = "users"; is not set
      group = "users";
      dataDir = "/home/${defaultUser}/";
      guiAddress = if config.networking.hostName == "srvr" then "0.0.0.0:8384" else "127.0.0.1:8384";
      guiPasswordFile = config.age.secrets.syncthing.path;
      settings = {
        gui.user = "${defaultUser}";
        devices = {
          "zenfone" = { id = "YGHKFE7-CKPD3XY-EJQJWSJ-7VA6N35-2LENZ7H-PE2CEBR-WFFXDQN-KIBVPQ2"; };
        };
        folders."Sync" = {
          path = "/home/${defaultUser}/Sync";
          devices = [
            "zenfone"
          ];
        };
      };
    };

    # Encrypt/decrypt
    environment.systemPackages = with pkgs; [ gocryptfs ];
  };

  flake.modules.homeManager.feature-syncthing = { ... }:
  {};
}
