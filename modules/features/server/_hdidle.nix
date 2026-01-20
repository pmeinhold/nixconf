{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    hd-idle
  ];

  systemd.services.hd-idle = {
    enable = true;
    description = "HDD spin down daemon";
    wantedBy = [ "multi-user.target" ];
    unitConfig = {
      Type = "simple";
    };
    serviceConfig = {
      ExecStart = "${pkgs.hd-idle}/bin/hd-idle -l /var/log/hd-idle.log -i 600 -a sdb -i 600 -a sda -i 600 -a sdc -i 600 -a sdd -i 600";
    };
  };
}
