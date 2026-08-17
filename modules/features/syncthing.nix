{ config, inputs, ... }:
let
  flakeConfig = config;
  defaultUser = "paulm";
in
{
  flake.modules.nixos.feature-syncthing = { config, ... }:
  {
    services.syncthing = {
      # enable = true;
      openDefaultPorts = true;
      user = "${defaultUser}";
      guiAddress = if config.networking.hostName == "srvr" then "0.0.0.0:8384" else "127.0.0.1:8384";
      settings = {
        gui.user = "${defaultUser}";
        # devices = {
        #   "device1" = { id = "DEVICE-ID-GOES-HERE"; };
        #   "device2" = { id = "DEVICE-ID-GOES-HERE"; };
        # };
        folders."Sync" = {
          path = "/home/${defaultUser}/Sync";
          # devices = [ "device1" "device2" ];
        };
      };
      # dataDir = "/home/${defaultUser}/";
      # settings.folders."Sync".path = "/home/${defaultUser}/Sync";
    };
  };

  flake.modules.homeManager.feature-syncthing = { ... }:
  {};
}
