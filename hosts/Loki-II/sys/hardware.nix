{ config, pkgs, lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot = {
    loader = {
      systemd-boot.enable = false;
      grub = {
        enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "amdgpu" ];
    };
    kernelModules = [ "kvm-amd" ];
    kernel.sysctl = { "vm.swappiness" = 80; };
  };
  hardware = {
    xone.enable = true;
    xpadneo.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };
    graphics.extraPackages = [ pkgs.rocmPackages.clr.icd ];
    amdgpu = {
      opencl.enable = true;
      overdrive.enable = true;
    };

    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    bluetooth = {
      enable = true;
    };
  };
  services.xserver.videoDrivers = [ "amdgpu" ];
  systemd.tmpfiles.rules = 
  let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [
        rocblas
        hipblas
        clr
      ];
    };
  in [
    "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  ];
}
