{
  modulesPath,
  inputs,
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

    kernelParams = ["mt7921e.disable_aspm=y"];

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
    device = "/dev/disk/by-uuid/6c21f34c-10ed-4c3f-97d4-22aeae01b757";
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
    device = "/dev/disk/by-uuid/b17035bd-13ff-4864-88b7-03e21f34d603";
    fsType = "btrfs";
    options = [
      "noatime"
      "x-gvfs-show"
    ];
  };
}
