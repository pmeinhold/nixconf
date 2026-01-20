{ ... }:
{
  flake.modules.nixos.feature-libvirt = { lib, pkgs, ... }: {
    virtualisation = {
      libvirtd = {
        enable = true;

        # Enable TPM emulation (optional)
        # install pkgs.swtpm system-wide for use in virt-manager (optional)
        qemu.swtpm.enable = true;
      };

      # Enable USB redirection (optional)
      spiceUSBRedirection.enable = true;
    };

    # To use default libvirt network, install dnsmasq, whitelist the interface and run commands:
    # virsh net-autostart default
    # virsh net-start default
    environment.systemPackages = with pkgs; [
      dnsmasq
      virt-manager
    ];
    networking.firewall.trustedInterfaces = [ "virbr0" ];
  };
}
