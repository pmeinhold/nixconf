{ self, inputs, ... }:
{
  flake.modules.nixos.feature-niri = { lib, pkgs, ... }:
  {
    programs.niri.enable = true;
  };

  flake.modules.homeManager.feature-niri = { lib, pkgs, ... }:
  {
  };
}
