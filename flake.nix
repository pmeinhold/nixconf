{
  description = "My Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    jovian.inputs.nixpkgs.follows = "nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    import-tree.url = "github:vic/import-tree";

    agenix.url = "github:ryantm/agenix";

    catppuccin.url = "github:catppuccin/nix";#/release-25.05";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        # "Enables" flake parts modules
        inputs.flake-parts.flakeModules.modules
        # Imports all of the top-level modules (the files under `./modules`)
        (inputs.import-tree ./modules)
      ];
    };

  # outputs = { self, nixpkgs, nixpkgs-unstable, flake-parts, home-manager, jovian, agenix, catppuccin, ... }@inputs:
  # let
  #   system = "x86_64-linux";
  #   pkgs = nixpkgs.legacyPackages.${system};
  #   pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
  #   stateVersion = "25.11";
  #   username = "paulm";
  # in
  # {
  #   nixosConfigurations = {
  #     lars = nixpkgs.lib.nixosSystem {
  #       inherit system;
  #       specialArgs = {
  #         inherit inputs stateVersion username pkgs-unstable;
  #         desktop = "yes";
  #         hostname = "lars";
  #       };
  #       modules = [
  #         ./host
  #         agenix.nixosModules.default
  #         catppuccin.nixosModules.catppuccin
  #       ];
  #     };
  #     deck = nixpkgs.lib.nixosSystem {
  #       inherit system;
  #       specialArgs = {
  #         inherit inputs stateVersion username pkgs-unstable;
  #         desktop = null;
  #         hostname = "deck";
  #       };
  #       modules = [
  #         ./host
  #         agenix.nixosModules.default
  #         jovian.nixosModules.default
  #         catppuccin.nixosModules.catppuccin
  #       ];
  #     };
  #     t480 = nixpkgs.lib.nixosSystem {
  #       inherit system;
  #       specialArgs = {
  #         inherit inputs stateVersion username pkgs-unstable;
  #         desktop = "yes";
  #         hostname = "t480";
  #       };
  #       modules = [
  #         ./host
  #         agenix.nixosModules.default
  #         catppuccin.nixosModules.catppuccin
  #       ];
  #     };
  #     # Headless
  #     srvr = nixpkgs.lib.nixosSystem {
  #       inherit system;
  #       specialArgs = {
  #         inherit inputs stateVersion username pkgs-unstable;
  #         desktop = null;
  #         hostname = "srvr";
  #       };
  #       modules = [
  #         ./host
  #         agenix.nixosModules.default
  #         catppuccin.nixosModules.catppuccin
  #       ];
  #     };
  #   };

  #   homeConfigurations = {
  #     # Desktop machines
  #     "${username}@lars" = home-manager.lib.homeManagerConfiguration {
  #       inherit pkgs; # do 'pkgs = pkgs-unstable' if you want unstable
  #       extraSpecialArgs = {
  #         inherit inputs stateVersion username;
  #         desktop = "hyprland";
  #         hostname = "lars";
  #       };
  #       modules = [
  #         ./home
  #         catppuccin.homeModules.catppuccin
  #       ];
  #     };
  #     "${username}@t480" = home-manager.lib.homeManagerConfiguration {
  #       inherit pkgs;
  #       extraSpecialArgs = {
  #         inherit inputs stateVersion username;
  #         desktop = "hyprland";
  #         hostname = "t480";
  #       };
  #       modules = [
  #         ./home
  #         ./home/kmonad.nix # Laptop keyboard with Miryoku
  #         catppuccin.homeModules.catppuccin
  #       ];
  #     };
  #     "${username}@deck" = home-manager.lib.homeManagerConfiguration {
  #       inherit pkgs;
  #       extraSpecialArgs = {
  #         inherit inputs stateVersion username;
  #         desktop = null;
  #         hostname = "deck";
  #       };
  #       modules = [
  #         ./home
  #         ./home/desktop/terminal.nix
  #         ./home/desktop/browser.nix
  #         ./home/desktop/emulation.nix
  #         catppuccin.homeModules.catppuccin
  #       ];
  #     };
  #     "pmeinhold@opt-008545.zib.de" = home-manager.lib.homeManagerConfiguration {
  #       inherit pkgs; # do 'pkgs = pkgs-unstable' if you want unstable
  #       extraSpecialArgs = {
  #         inherit inputs stateVersion;
  #         username = "pmeinhold";
  #         desktop = null;
  #         hostname = "opt-008545.zib.de";
  #       };
  #       modules = [
  #         ./home
  #         ./home/desktop/terminal.nix
  #         catppuccin.homeModules.catppuccin
  #       ];
  #     };
  #     # Headless machines
  #     "${username}@srvr" = home-manager.lib.homeManagerConfiguration {
  #       inherit pkgs;
  #       extraSpecialArgs = {
  #         inherit inputs stateVersion username;
  #         desktop = null;
  #         hostname = "srvr";
  #       };
  #       modules = [
  #         ./home
  #         catppuccin.homeModules.catppuccin
  #       ];
  #     };
  #   };
}
