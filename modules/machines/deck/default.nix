{ lib, config, inputs, ... }:
let
  hasJovian = inputs ? jovian;
in
{
  flake.nixosConfigurations.deck = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      config.flake.modules.nixos.feature-base
      config.flake.modules.nixos.feature-desktop

      ({ ... }: {
        networking.hostName = "deck";

        boot.loader.systemd-boot.enable = true;

        programs.gamemode.enable = true;

        services.desktopManager.gnome.enable = true;
        services.displayManager.gdm.enable = false;
        # services.displayManager.autoLogin.user = "paulm";

        # Use jovian if available
        imports = lib.optional hasJovian inputs.jovian.nixosModules.default;
        jovian = lib.optionalAttrs hasJovian {
          steam = {
            enable = true;
            autoStart = true;
            user = "paulm";
            desktopSession = "gnome";
          };
          devices.steamdeck.enable = true;
        };

        system.stateVersion = "25.11";
      })

    ];

  };
}
