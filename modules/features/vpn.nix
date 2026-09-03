{ inputs, ... }:
{
  flake.modules.nixos.feature-vpn = { pkgs, lib, ... }: {
    services.nordvpn.enable = true;
  };

  environment.systemPackages = with pkgs; [
    nordvpn
    qbittorrent
  ];
}
