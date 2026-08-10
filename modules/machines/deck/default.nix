{ lib, config, inputs, ... }:
let
  hasJovian = inputs ? jovian;
in
{
  flake.nixosConfigurations.deck = inputs.nixpkgs-unstable.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      config.flake.modules.nixos.feature-base
      # config.flake.modules.nixos.feature-desktop
      config.flake.modules.nixos.feature-gnome

      ({ ... }: {
        networking.hostName = "deck";

        boot.loader.systemd-boot.enable = true;

        programs.gamemode.enable = false;

        services.desktopManager.gnome.enable = true;
        services.displayManager.gdm.enable = false;
        # services.displayManager.autoLogin = {
        #   enable = true;
        #   user = "paulm";
        # };

        services.openssh = {
          enable = true;
          ports = [ 69 ];
          settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
          };
        };

        # programs.steam = {
        #   enable = true;
        #   remotePlay.openFirewall = false;
        #   dedicatedServer.openFirewall = false;
        # };

        # services.displayManager.sddm.wayland.enable = true;
        # services.displayManager.autoLogin.user = "paulm";

        # Use jovian if available
        imports = lib.optional hasJovian inputs.jovian.nixosModules.default;
        jovian = lib.optionalAttrs hasJovian {
          devices.steamdeck.enable = true;
          steam = {
            enable = true;
            autoStart = true;
            desktopSession = "gnome";
            user = "paulm";
          };
        };

        system.stateVersion = "25.11";
      })
    ];
  };

  flake.homeConfigurations."paulm@deck" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-desktop
      config.flake.modules.homeManager.feature-emulation

      ({ ... }: {
        home.stateVersion = "25.11";
      })
    ];
  };

}
