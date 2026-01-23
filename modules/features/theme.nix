{ inputs, ... }:
let
  hasCatppuccin = inputs ? catppuccin;
  flavor = "mocha";
  accent = "sky";
in
{
  flake.modules.nixos.feature-theme = { lib, pkgs, ... }:
  {
    # Use catppuccin if available
    imports = lib.optional hasCatppuccin inputs.catppuccin.nixosModules.catppuccin;
    catppuccin = lib.optionalAttrs hasCatppuccin {
      enable = true;
      inherit flavor accent;
    };
  };

  flake.modules.homeManager.feature-theme = { lib, pkgs, ... }:
  {
    # Use catppuccin if available
    imports = lib.optional hasCatppuccin inputs.catppuccin.homeModules.catppuccin;
    catppuccin = lib.optionalAttrs hasCatppuccin {
      enable = true;
      inherit flavor accent;
      cursors.accent = "light";
    };

    # Catppuccin GTK theme is archived, so I must explicitly configure it.
    gtk.theme = {
      name = "Catppuccin-GTK-Dark";
      package = pkgs.magnetic-catppuccin-gtk;
    };
    # github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme

    qt = {
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };
  };
}
