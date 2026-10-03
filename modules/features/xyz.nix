{ config, ... }:
let
  flakeConfig = config;
in
{
  flake.modules.nixos.feature-xyz = { ... }:
  {
  };

  flake.modules.homeManager.feature-xyz = { ... }:
  {
  };
}
