{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ mergerfs ];

  fileSystems."/mnt/storage" = {
    fsType = "fuse.mergerfs";
    device = "/mnt/disk*";
    # options = [ "cache.files=off" "category.create=pfrd" ];
  };

}
