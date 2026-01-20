{ ... }:
{
  flake.modules.nixos.feature-podman = { pkgs, ... }: {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        # Required for containers under podman-compose to be able to talk to each other.
        # defaultNetwork.settings.dns_enabled = true;
      };
    };
    environment.systemPackages = with pkgs; [
      podman-compose
    ];
  };
}
# { lib, pkgs, username, ... }:

# {
#   virtualisation = {
#     containers.enable = true;
#     podman = {
#       enable = true;
#       dockerCompat = false;
#       defaultNetwork.settings.dns_enabled = true;
#     };
#     # libvirtd.enable = true;
#   };
#   environment.systemPackages = with pkgs; [
#     dive
#     podman-tui
#     podman-compose
#     podman-desktop
#   ];
#   # programs.virt-manager.enable = true;

#   users.users."${username}" = {
#     isNormalUser = true;
#     extraGroups = [ "podman" ];
#   };

#   # networking.firewall.trustedInterfaces = [
#   #   "virbr0"
#   #   "vnet0"
#   #   "vnet2"
#   #   "vnet4"
#   # ];
#   # networking.interfaces.wlp3s0.ipv4.addresses = [{
#   #   address = "10.25.0.2";
#   #   prefixLength = 24;
#   # }];
# }
