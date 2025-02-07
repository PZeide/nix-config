{
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-hidpi
  ];

  boot = {
    kernelModules = ["kvm-intel"];

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
    device = "/dev/disk/by-uuid/64c2222d-822a-4152-9b99-f622dc11e778";
    fsType = "ext4";
    options = ["noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/BFE6-3F4D";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/8E82CA0E82C9FAAB";
    fsType = "ntfs3";
    options = [
      "uid=1000"
      "gid=1000"
      "dmask=007"
      "fmask=117"
      "nohidden"
      "sys_immutable"
      "windows_names"
    ];
  };
}
