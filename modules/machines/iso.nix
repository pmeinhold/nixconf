{ lib, config, inputs, ... }:
{
  flake.nixosConfigurations.iso = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.flake.modules.nixos.feature-base
      config.flake.modules.nixos.feature-desktop
      config.flake.modules.nixos.feature-kmonad

      ({ modulesPath, ... }: {
        imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
        networking.hostName = "nixiso";

        nixpkgs.config.allowUnfree = true;
        nix.settings.experimental-features = [ "nix-command" "flakes" ];

        # services.openssh = {
        #   enable = true;
        #   settings = {
        #     PermitRootLogin = "no";
        #     PasswordAuthentication = true;
        #   };
        # };
      })

    ];
  };
}
