{ lib, config, inputs, ... }:
{
  flake.nixosConfigurations.lars = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      config.flake.modules.nixos.feature-base
      config.flake.modules.nixos.feature-desktop
      config.flake.modules.nixos.feature-podman
      # config.flake.modules.nixos.feature-libvirt

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

  flake.homeConfigurations."paulm@lars" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-desktop
      config.flake.modules.homeManager.feature-emulation

      ({ pkgs, ... }: {
        programs.retroarch.settings = {
          video_driver = "glcore"; # vulkan, glcore, gl, gl1, sdl
        };
        home.packages = with pkgs; [
          prismlauncher # minecraft
          discord
        ];
        home.stateVersion = "25.11";
      })

    ];
  };
}
