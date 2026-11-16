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
          "zenfone" = { id = "BUOY3RQ-TAEEMB5-XNCQYNI-JDECEHE-GXQU6YN-VXHPGFG-B5F7X2N-UGPHOAX"; };
          "lars" = { id = "EMHP2R4-RO4333P-6YQQGZD-ZRWJTXM-NCA3B5G-WQ3OZD6-LMSDQAW-BKFVJAC"; };
          "srvr" = { id = "2EJLRFK-CHGXUAD-6GKI7PU-ZHIDG5V-G2I6KWY-RK2IDC7-TM2WWXZ-QST26QP"; };
        };
        folders."Sync" = {
          path = "/home/${defaultUser}/Sync";
          devices = [
            "zenfone"
            "lars"
            "srvr"
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
