{ config, inputs, ... }:
{
  flake.homeConfigurations."paulm@x220" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-desktop
      config.flake.modules.homeManager.feature-kmonad-miryoku

      ({ ... }: {
        home.stateVersion = "25.11";
      })

    ];
  };

  flake.homeConfigurations."paulm@srvr" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell

      ({ ... }: {
        home.stateVersion = "25.11";
      })

    ];
  };

  flake.homeConfigurations."paulm@lars" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-desktop
      config.flake.modules.homeManager.feature-emulation

      ({ pkgs, ... }: {
        programs.retroarch.settings = {
          video_driver = "glcore"; # vulkan, glcore, gl, gl1, sdl
        };
        home.packages = with pkgs; [ stretchly ];
        home.stateVersion = "25.11";
      })

    ];
  };

  flake.homeConfigurations."paulm@deck" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-desktop
      config.flake.modules.homeManager.feature-emulation

      ({ ... }: {
        wayland.windowManager.hyprland.settings.monitor = [ "eDP-1, 800x1280@60, auto, 1, transform, 3" ];
        home.stateVersion = "25.11";
      })

    ];
  };

  # ./nixp.sh nix-shell -p home-manager nix --run 'home-manager switch --flake .#pmeinhold'
  # foot launch command: /scratch/opt/pmeinhold/dev/nixconf/nixp.sh nix-shell -p fish --command "fish -C 'set -gx PATH ~/.nix-profile/bin $PATH && foot fish'"
  # Put these into .bashrc:
  # export NP_LOCATION=/srv/public/[opt-008545/]pmeinhold
  # export NP_RUNTIME=bwrap
  # export XDG_CACHE_HOME="$NP_LOCATION"/.cache
  # export PATH=~/.nix-profile/bin:$PATH # for bash
  flake.homeConfigurations."pmeinhold" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-browser
      config.flake.modules.homeManager.feature-terminal

      ({ pkgs, ... }: {
        home = {
          stateVersion = "25.11";
          username = "pmeinhold";
          homeDirectory = "/home/optimi/pmeinhold";
          packages = with pkgs; [ nix ];
        };
      })

    ];
  };

  flake.homeConfigurations.rie = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-desktop

      ({ pkgs, ... }: {
        home = {
          stateVersion = "25.11";
          username = "rie";
          homeDirectory = "/home/rie";
          packages = with pkgs; [
            vim
            python3
          ];
        };
        programs.neovim.enable = false;
        wayland.windowManager.hyprland.settings.input.kb_layout = "de";
      })

    ];
  };
}
