{ lib, config, inputs, ... }:
{
  flake.nixosConfigurations.x220 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      config.flake.modules.nixos.feature-base
      config.flake.modules.nixos.feature-desktop
      config.flake.modules.nixos.feature-kmonad

      ({ pkgs, ... }: {
        boot.loader.grub = {
          enable = true;
          device = "/dev/sda";
        };

        networking.hostName = "x220";

        # input/uinput groups to use kmonad as a user
        users = {
          groups.uinput = { };
          users.paulm.extraGroups = [ "input" "uinput" ];
        };

        users.users.rie = {
          isNormalUser = true;
          home = "/home/rie";
          shell = pkgs.bashInteractive;
          extraGroups = [
            "wheel"
            "networkmanager"
          ];
        };

        system.stateVersion = "25.11";
      })

    ];
  };

  flake.homeConfigurations."paulm@x220" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-desktop
      config.flake.modules.homeManager.feature-kmonad-miryoku

      ({ ... }: {
        feature.kmonad.miryoku.thumbRow = "lalt spc tab ralt cmp del";
        home.stateVersion = "25.11";
      })

    ];
  };
}
