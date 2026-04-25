{ lib, config, inputs, ... }:
{
  flake.nixosConfigurations.t480 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      config.flake.modules.nixos.feature-base
      config.flake.modules.nixos.feature-desktop
      config.flake.modules.nixos.feature-kmonad

      ({ pkgs, ... }: {
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
            prime = {
              sync.enable = true;
              # find out by 'sudo lshw -c display' (and convert to decimal)
              intelBusId = "PCI:0:2:0";
              nvidiaBusId = "PCI:1:0:0";
            };
          };
        };

        services = {
          xserver.videoDrivers = [ "nvidia" ];
          throttled.enable = true;
          tailscale.useRoutingFeatures = "client";
          logind = {
            lidSwitch = "lock";
            lidSwitchExternalPower = "lock";
            lidSwitchDocked = "lock";
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
}
