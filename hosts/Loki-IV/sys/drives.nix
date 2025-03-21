{ ... }: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/55f80e0d-57ef-41c1-a283-cf00f71dfcb5";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/0FD5-2648";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/2358ee51-a3b7-456b-b2eb-a151db6b5fed"; }];
}
