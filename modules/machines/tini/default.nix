{ lib, config, inputs, ... }:
{
  flake.nixosConfigurations.tini = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      config.flake.modules.nixos.feature-base
      config.flake.modules.nixos.feature-desktop

      ({ ... }: {
        networking.hostName = "tini";

        boot.loader.grub = {
          enable = true;
          device = "nodev";
        };

        hardware.nvidia = {
          open = false;
          modesetting.enable = true;
        };
        services.xserver.videoDrivers  = [ "nvidia"  ];

        services.desktopManager.gnome.enable = true;
        services.displayManager.autoLogin = {
          enable = true;
          user = "paulm";
        };

        services.openssh = {
          enable = true;
          settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = true;
          };
        };

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
