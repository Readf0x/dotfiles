{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.cifs-utils ];
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/82ce86f1-fcbf-4456-8270-6429af080824";
      fsType = "ext4";
      options = [
        "x-gvfs-icon=drive-harddisk-root"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/4617-7B23";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/baf8ab4f-19fa-4a6f-8b32-476698e8c2f5";
      fsType = "ext4";
    };
    "/mnt/Games" = {
      device = "/dev/disk/by-uuid/d54e5f31-d22a-4773-981c-3fa0c774be22";
      fsType = "ext4";
    };
    "/mnt/GamesHDD" = {
      device = "/dev/disk/by-uuid/8141743e-c948-4760-9467-abd44c1b5ec0";
      fsType = "ext4";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/0077b1f5-557d-4dd1-8a7e-c5c9353db470"; }];
}
