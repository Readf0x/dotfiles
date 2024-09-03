{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_zen;
    plymouth = {
      enable = true;
      # theme = "infinite_seal";
    };
  };
  hardware = {
    xone.enable = true;
    xpadneo.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };
    graphics.extraPackages = [ pkgs.rocmPackages.clr.icd ];
    amdgpu.opencl.enable = true;

    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
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
