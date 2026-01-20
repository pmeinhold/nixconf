{ ... }:
{
  flake.modules.nixos.feature-ripping = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      libvirt
      libdvdnav
      libdvdcss
      libdvdread
      libaacs
      libbluray
      libcdio
      libcdio-paranoia
    ];
  };
}
