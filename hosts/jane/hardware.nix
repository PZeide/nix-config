{
  modulesPath,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    (inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime + "/ampere")
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
  ];

  hardware = {
    amdgpu.initrd.enable = false;

    nvidia = {
      modesetting.enable = true;
      powerManagement.finegrained = true;

      prime = {
        amdgpuBusId = "PCI:6:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  boot = {
    kernelModules = ["kvm-amd"];

    # On my Legion 5 laptop, the tsc clocksource is stated as "unreliable" but that causes performance issues, disable hpet and force tsc
    kernelParams = ["mt7921e.disable_aspm=y" "tsc=reliable" "clocksource=tsc" "nohpet"];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5f911220-0283-4b64-9813-fcd429b5456c";
    fsType = "ext4";
    options = ["noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0897-A178";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/A8DCCD9EDCCD6762";
    fsType = "ntfs3";
    options = [
      "uid=1000"
      "gid=1000"
      "fmask=133"
      "dmask=022"
      "nohidden"
      "windows_names"
      "x-gvfs-show"
    ];
  };
}
