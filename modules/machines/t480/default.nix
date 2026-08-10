{ lib, config, inputs, ... }:
{
  flake.nixosConfigurations.t480 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      config.flake.modules.nixos.feature-base
      config.flake.modules.nixos.feature-desktop
      config.flake.modules.nixos.feature-kmonad

      ({ config, pkgs, ... }: {
        boot.loader.systemd-boot.enable = true;

        networking.hostName = "t480";

        # input/uinput groups to use kmonad as a user
        users = {
          groups.uinput = { };
          users.paulm.extraGroups = [ "input" "uinput" ];
        };

        hardware = {
          graphics = {
            enable = true;
            extraPackages = with pkgs; [ nvidia-vaapi-driver ];
          };
          # https://nixos.wiki/wiki/Nvidia
          # GeForce MX150 is Pascal (Chip GP108): https://www.notebookcheck.com/NVIDIA-GeForce-MX150-GPU-Benchmarks-und-Specs-der-GT-1030-fuer-Laptops.223528.0.html
          # I.e., older than Turing: https://en.wikipedia.org/wiki/Pascal_(microarchitecture)
          nvidia = {
            modesetting.enable = true;
            powerManagement.enable = false; # NVIDIA will be on full-time
            powerManagement.finegrained = false;
            open = false; # Only set to false if older than Turing architecture (2018)
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
            prime = {
              sync.enable = true;
              # find out by 'sudo lshw -c display' (and convert to decimal)
              intelBusId = "PCI:0:2:0";
              nvidiaBusId = "PCI:1:0:0";
            };
          };
        };
        # Disable Intel video which might interfere with nvidia
        # boot.kernelParams = [ "module_blacklist=i915" ];

        services = {
          xserver.videoDrivers = [ "nvidia" ];
          throttled.enable = true;
          tailscale.useRoutingFeatures = "client";
          logind.settings.Login = {
            HandleLidSwitch = "lock";
            HandleLidSwitchExternalPower = "lock";
            HandleLidSwitchDocked = "lock";
          };
          tlp = {
            enable = false;
            settings = {
              #Optional helps save long term battery health
              STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
              STOP_CHARGE_THRESH_BAT1 = 80;
              # START_CHARGE_THRESH_BAT0 = 80; # this and bellow it starts to charge
              # START_CHARGE_THRESH_BAT1 = 80;

              CPU_SCALING_GOVERNOR_ON_AC = "performance";
              CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

              CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
              CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
            };
          };
        };

        system.stateVersion = "25.11";
      })

    ];
  };

  flake.homeConfigurations."paulm@t480" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-desktop
      config.flake.modules.homeManager.feature-kmonad-miryoku

      ({ ... }: {
        # wayland.windowManager.hyprland.settings.monitor = [
        #   "DP-1,  3440x1440@60, auto, 1"
        #   "eDP-1, 1920x1080@60, auto, 1, mirror, DP-1"
        # ];
        # programs.waybar.settings.mainBar."battery".bat = "BAT0";
        home.stateVersion = "25.11";
      })
    ];
  };
}
