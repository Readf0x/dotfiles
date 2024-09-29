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
      device = "/dev/disk/by-uuid/5733a149-db2c-43a4-bbe9-a4b87bde6e39";
      fsType = "ext4";
    };
    "/mnt/Games" = {
      device = "/dev/disk/by-uuid/d54e5f31-d22a-4773-981c-3fa0c774be22";
      fsType = "ext4";
    };
    "/mnt/GamesHDD" = {
      device = "/dev/disk/by-uuid/40c276dc-9d93-4394-b85f-b0f6192567f1";
      fsType = "ext4";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/0077b1f5-557d-4dd1-8a7e-c5c9353db470"; }];
}
