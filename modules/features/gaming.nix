{ config, ... }:
let
  flakeConfig = config;
in
{
  flake.modules.nixos.feature-gaming = { pkgs, ... }:
  {
    programs.xwayland.enable = true;

    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
      # package = pkgs.steam.override {
      #   extraPkgs = pkgs': with pkgs'; [
      #     libXcursor
      #     libXi
      #     libXinerama
      #     libXScrnSaver
      #     libpng
      #     libpulseaudio
      #     libvorbis
      #     stdenv.cc.cc.lib # Provides libstdc++.so.6
      #     libkrb5
      #     keyutils
      #   ];
      # };
    };
  };

  flake.modules.homeManager.feature-gaming = { ... }:
  {
  };
}
