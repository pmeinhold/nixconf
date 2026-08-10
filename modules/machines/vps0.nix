{ lib, config, inputs, ... }:
let
  domain = "pmeinhold.duckdns.org";
in
{
  flake.nixosConfigurations.vps0 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.flake.modules.nixos.feature-base

      ({ config, lib, pkgs, ... }: {
        networking.hostName = "vps0";

        boot.loader.grub.enable = true;
        boot.loader.grub.device = "/dev/sda";
        boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" "ext4" ];

        fileSystems."/" = {
          device = "/dev/disk/by-label/nixos";
          fsType = "ext4";
        };
        fileSystems."/boot" = {
          device = "/dev/disk/by-label/boot";
          fsType = "ext4";
        };

        users.users.root.hashedPassword = "!"; # Disable root login

        security.sudo.wheelNeedsPassword = false;

        networking.firewall = {
          enable = true;
          allowedTCPPorts = [
            69
            80
            443
          ];
          allowedUDPPorts = [
          ];
        };

        services = {
          caddy = {
            enable = true;
            # virtualHosts.${domain}.extraConfig = ''
            #   respond "Hello, world!"
            # '';
            virtualHosts.${domain}.extraConfig = ''
              root * /var/www/pmeinhold
              file_server
            '';
          };
          openssh = {
            enable = true;
            ports = [ 69 ];
            settings = {
              PermitRootLogin = "no";
              PasswordAuthentication = false;
              KbdInteractiveAuthentication = false;
            };
          };
        };

        system.stateVersion = "25.11";
      })

    ];
  };

  flake.homeConfigurations."paulm@vps0" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell

      ({ ... }: {
        home.stateVersion = "25.11";
      })

    ];
  };

}
