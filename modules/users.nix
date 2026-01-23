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

  # Put these into .bashrc:
  # --- Enable fish/nix environment/profile ---
  # export STORE="/srv/public/pmeinhold"
  # export MYHOME="/scratch/opt/pmeinhold"
  # export PATH=~/.nix-profile/bin:$MYHOME:$PATH
  # cd $MYHOME
  # if [[ $- == *i* ]] && command -v fish >/dev/null 2>&1; then
  #     exec fish
  # fi
  flake.homeConfigurations."pmeinhold@opt" = inputs.home-manager.lib.homeManagerConfiguration {
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

  flake.homeConfigurations."pmeinhold@z1" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell

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
