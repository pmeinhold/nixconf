{ config, inputs, ... }:
let
  defaultUser = "paulm";
in
{
  flake.modules.nixos.feature-base = { lib, pkgs, ... }:
  {
    imports = [
      config.flake.modules.nixos.feature-theme
    ];

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
          "wheel"
          "networkmanager"
        ];
      };
    };

    environment = {
      systemPackages = with pkgs; [
        git
        neovim
      ];
      variables.EDITOR = "nvim";
    };

    boot.loader = {
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
      # syncthing = {
      #   enable = true;
      #   openDefaultPorts = true;
      #   user = "${defaultUser}";
      #   dataDir = "/home/${defaultUser}/";
      #   guiAddress = if hostname == "srvr" then "0.0.0.0:8384" else "127.0.0.1:8384";
      #   settings.folders."Sync".path = "/home/${defaultUser}/Sync";
      # };
    };

    networking = {
      firewall.enable = true;
      networkmanager.enable = true;
    };
  };

  flake.modules.homeManager.feature-base = { lib, pkgs, ... }:
  {
    imports = [
      config.flake.modules.homeManager.feature-theme
    ];

    nixpkgs.config.allowUnfree = true;

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
