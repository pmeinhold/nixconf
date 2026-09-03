{ inputs, ... }:
{
  flake.modules.nixos.feature-tor = { pkgs, lib, ... }: {
    services.tor = {
      enable = false;
      client.enable = true;
    };
  };
}
