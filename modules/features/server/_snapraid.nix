{ pkgs, ... }:

{
  # SnapRAID manual: https://www.snapraid.it/manual
  services.snapraid = {
    enable = true;
    dataDisks = {
      disk1 = "/mnt/disk1";
      disk2 = "/mnt/disk2";
    };
    parityFiles = [
      "/mnt/parity/snapraid.parity"
    ];
    contentFiles = [
      # "/var/snapraid.content" permission denied.
      "/mnt/disk1/snapraid.content"
      "/mnt/disk2/snapraid.content"
    ];
    sync.interval = "13:00";
    scrub.interval = "Mon *-*-* 15:00:00";
  };
}
