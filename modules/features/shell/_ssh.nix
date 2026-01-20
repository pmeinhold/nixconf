{ pkgs, username, ... }:

{
  #services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*".identityFile = "~/.ssh/id_ed25519";
      "lars" = {
        hostname = "lars";
        user = "paulm";
      };
      "srvr" = {
        hostname = "srvr";
        user = "paulm";
      };
      "login01" = {
        hostname = "login01.zib.de";
        user = "pmeinhold";
      };
      "z1" = {
        hostname = "z1.zib.de";
        user = "pmeinhold";
        proxyJump = "login01";
      };
      "opt-008545" = {
        hostname = "opt-008545.zib.de";
        user = "pmeinhold";
        proxyJump = "login01";
      };
    };
  };
}
