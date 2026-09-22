{ lib, config, inputs, ... }:
let
  flakeConfig = config;
  domain = "pmeinhold.duckdns.org";
in
{
  flake.nixosConfigurations.vps0 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      flakeConfig.flake.modules.nixos.feature-base
      flakeConfig.flake.modules.nixos.feature-podman

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

        age.secrets.obsidian_remote_password = {
          file = ../../secrets/obsidian_remote_password.age;
        };

        virtualisation.oci-containers.backend = "podman";
        virtualisation.oci-containers.containers.obsidian-remote = {
          image = "ghcr.io/sytone/obsidian-remote:latest";
          ports = [ "127.0.0.1:8080:8080" ];
          volumes = [
            "/var/lib/obsidian-remote/vaults:/vaults"
            "/var/lib/obsidian-remote/config:/config"
          ];
          environment = {
            PUID = "1000";
            PGID = "1000";
            TZ = "Europe/Berlin";
            KEYBOARD = "de-de-qwertz";
            SUBFOLDER = "/obsidian/";
            # CUSTOM_USER = "paulm";
          };
          # environmentFiles = [ config.age.secrets.obsidian_remote_password.path ];
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

              handle /obsidian/* {
                reverse_proxy 127.0.0.1:8080
              }

              basic_auth /obsidian/* {
                # Username "julian", password "hiccup"
                julian $2a$14$KFyL/K6VBke79uxL5QqCaet87Hd/3KVtmAP4ev./hQ0MS5ZFVjL.2
              }
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
}
