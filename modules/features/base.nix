{ config, inputs, ... }:
let
  defaultUser = "paulm";
  flakeConfig = config;
in
{
  flake.modules.nixos.feature-base = { config, lib, pkgs, ... }:
  {
    imports = [
      inputs.agenix.nixosModules.default
      flakeConfig.flake.modules.nixos.feature-theme
    ];

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = lib.mkDefault "en_DK.UTF-8";

    programs.fish.enable = true;
    users = {
      defaultUserShell = pkgs.fish;
      users.${defaultUser} = {
        isNormalUser = true;
        home = lib.mkDefault "/home/${defaultUser}";
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4vpPLYf+6rzvDomLju8J+X7oOKxGNhN2C41sUx0b90 default" ];
        extraGroups = [
          "input"
          "wheel"
          "networkmanager"
        ];
      };
    };

    environment = {
      systemPackages = with pkgs; [
        git
        gnupg
        neovim
        jujutsu
        inputs.agenix.packages.${stdenv.hostPlatform.system}.default
      ];
      variables.EDITOR = "nvim";
    };

    boot.loader = lib.mkDefault {
      timeout = 2;
      systemd-boot = {
        configurationLimit = 4;
        memtest86.enable = true;
      };
      grub = {
        configurationLimit = 4;
        memtest86.enable = true;
        useOSProber = true;
      };
    };

    fonts = {
      fontconfig.enable = true;
      packages = with pkgs; [
        noto-fonts
        noto-fonts-color-emoji
        inconsolata
        nerd-fonts.inconsolata
      ];
    };

    services = {
      tailscale = {
        enable = true;
        useRoutingFeatures = lib.mkDefault "client";
      };
    };

    networking = {
      firewall.enable = true;
      networkmanager.enable = true;
    };
  };

  flake.modules.homeManager.feature-base = { lib, pkgs, ... }:
  {
    imports = [
      inputs.agenix.homeManagerModules.default
      flakeConfig.flake.modules.homeManager.feature-theme
      flakeConfig.flake.modules.homeManager.feature-defaultapps
    ];

    nixpkgs.config.allowUnfree = true;


    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    home.username = lib.mkDefault defaultUser;
    home.homeDirectory = lib.mkDefault "/home/${defaultUser}";

    programs.home-manager.enable = true;

    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      inconsolata
      nerd-fonts.inconsolata
    ];
  };
}
