{ config, ... }:
{
  flake.modules.nixos.feature-server = { ... }:
  {
    imports = [
      config.flake.modules.nixos.feature-hdidle
      config.flake.modules.nixos.feature-mergerfs
      config.flake.modules.nixos.feature-snapraid
      config.flake.modules.nixos.feature-jellyfin
      config.flake.modules.nixos.feature-immich
    ];
  };
}
