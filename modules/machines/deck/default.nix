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

      ({ pkgs, ... }: {
        networking.hostName = "deck";

        boot.loader.systemd-boot.enable = true;

        services.desktopManager.gnome.enable = true;
        services.displayManager.gdm.enable = false;

        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };
        services.udisks2.enable = true;

        # get libGL.so.1 into /run/current-system/sw/lib.
        # put the following into steam launch options of non-steam games:
        # LD_LIBRARY_PATH=/run/current-system/sw/lib %command%
        environment.systemPackages = with pkgs; [ libglvnd ];

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

        programs.steam.extraPackages = with pkgs; [ libGL ];

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
