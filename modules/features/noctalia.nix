{ self, inputs, ... }:
{
  flake.modules.nixos.feature-noctalia = { lib, pkgs, ... }:
  {
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services.tuned.enable = true;
    services.upower.enable = true;

    environment.systemPackages = with pkgs; [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  flake.modules.homeManager.feature-noctalia = { lib, pkgs, ... }:
  {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    # programs.noctalia-shell = {
    #   enable = true;
    #   settings = {};
    #     # (builtins.fromJSON (builtins.readFile ./noctalia.json)).settings;
    # };
    programs.noctalia = {
      enable = true;

      settings = { # This may also be a string or path to a .toml file.
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };

        wallpaper = {
          enabled = true;
          default.path = "/path/to/wallpapers/wallpaper.png";
        };
      };
    };
  };
}
