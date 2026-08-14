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
      config.flake.modules.nixos.feature-gnome
      config.flake.modules.nixos.feature-emulation

      ({ ... }: {
        networking.hostName = "deck";

        boot.loader.systemd-boot.enable = true;

        services.desktopManager.gnome.enable = true;
        services.displayManager.gdm.enable = false;

        services.tailscale.extraSetFlags = [
          "--operator=$USER"
        ];

        services.openssh = {
          enable = true;
          ports = [ 69 ];
          settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
          };
        };

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
}
