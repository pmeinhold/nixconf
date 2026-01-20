{ lib, config, inputs, ... }:
{
  flake.nixosConfigurations.lars = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      config.flake.modules.nixos.feature-base
      config.flake.modules.nixos.feature-desktop
      config.flake.modules.nixos.feature-podman
      config.flake.modules.nixos.feature-libvirt

      ({ ... }: {
        networking.hostName = "lars";

        boot.loader.systemd-boot.enable = true;

        services.openssh = {
          enable = true;
          settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = true;
          };
        };

        users.users.paulm.extraGroups = [ "libvirtd" ];

        programs.steam = {
          enable = true;
          remotePlay.openFirewall = false;
          dedicatedServer.openFirewall = false;
        };

        system.stateVersion = "25.11";
      })

    ];
  };
}
