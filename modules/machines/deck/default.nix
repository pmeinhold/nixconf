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
        services.displayManager.gdm.enable = true;
        services.displayManager.autoLogin = {
          enable = true;
          user = "paulm";
        };

        services.openssh = {
          enable = true;
          ports = [ 69 ];
          settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
          };
        };

        programs.steam = {
          enable = true;
          remotePlay.openFirewall = false;
          dedicatedServer.openFirewall = false;
        };

        # services.displayManager.sddm.wayland.enable = true;
        # services.displayManager.autoLogin.user = "paulm";

        # Use jovian if available
        imports = lib.optional hasJovian inputs.jovian.nixosModules.default;
        jovian = lib.optionalAttrs hasJovian {
          devices.steamdeck.enable = true;
          # steam = {
          #   enable = false;
          #   autoStart = false;
          #   user = "paulm";
          #   desktopSession = "gnome";
          # };
        };

        system.stateVersion = "25.11";
      })

    ];

  };
}
