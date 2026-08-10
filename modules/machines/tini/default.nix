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
          ports = [ 69 ];
          settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = true;
            KbdInteractiveAuthentication = false;
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

  flake.homeConfigurations."paulm@tini" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-desktop
      config.flake.modules.homeManager.feature-emulation

      ({ pkgs, ... }: {
        programs.retroarch.settings.video_driver = "glcore"; # vulkan, glcore, gl, gl1, sdl
        home.stateVersion = "25.11";
      })

    ];
  };
}
