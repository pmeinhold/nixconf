{ ... }:
{
  flake.modules.nixos.feature-server = { ... }:
  {
    imports = [
      ./_hdidle.nix
      ./_mergerfs.nix
      ./_snapraid.nix
      ./_jellyfin.nix
      ./_immich.nix
    ];
  };
}
