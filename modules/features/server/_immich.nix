{ pkgs, config, ... }:

{
  services.immich = {
    enable = true;
    port = 2283;
    host = "0.0.0.0";
    openFirewall = true;
    accelerationDevices = null;
    mediaLocation = "/mnt/storage/Immich";
  };
  users.users.immich.extraGroups = [ "video" "render" ];

  # Local backups with borg
  # Make sure to manually create a borg repo at the desired location beforehand with
  #   'sudo borg init --encryption=none <path-to-borg-repo>'
  # https://wiki.nixos.org/wiki/Immich
  services.borgbackup.jobs."Immich" = {
    paths = config.services.immich.mediaLocation;
    repo = "/mnt/storage/ImmichBorgBackup";
    startAt = "12:00"; # daily at that hh:mm on a 24hour clock https://www.man7.org/linux/man-pages/man7/systemd.time.7.html
    compression = "zstd";
    encryption.mode = "none";
    prune.keep = {
      daily = 7; # keep 7 end-of day
      weekly = 4; # keep 4 end-of-week
      monthly = -1;  # keep at least one archive for each month
    };
  };

  # services.nginx.virtualHosts."srvr" = {
  #   enableACME = true;
  #   forceSSL = true;
  #   locations."/" = {
  #     proxyPass = "http://[::1]:${toString config.services.immich.port}";
  #     proxyWebsockets = true;
  #     recommendedProxySettings = true;
  #     extraConfig = ''
  #       client_max_body_size 50000M;
  #       proxy_read_timeout   600s;
  #       proxy_send_timeout   600s;
  #       send_timeout         600s;
  #     '';
  #   };
  # };
}
