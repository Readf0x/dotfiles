if not test -d /mnt
	echo "Please partition your drive and mount it to /mnt"
	exit 1
end

if not test -d /mnt/sys/firmware
	mount -t efivarfs efivarfs /sys/firmware
end

echo "Generating config..."
nixos-generate-config --root /mnt
set -l hardware_config /mnt/etc/nixos/hardware-configuration.nix
echo "Done!"
echo "Cloning dotfiles..."
git clone https://github.com/readf0x/dotfiles
echo "Done!"
cd dotfiles
echo "Time to create host config!"
echo -n "Hostname: "
read host
mkdir -p hosts/$host/sys
cp /mnt/etc/nixos/hardware-configuration.nix hosts/$host/sys/hardware.nix
echo '{ ... }: {
  imports = [
    ./drives.nix
    ./hardware.nix
  ];

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
}' > hosts/$host/sys/default.nix
echo "Make sure to configure both /hosts/config.nix AND /hosts/<HOST>/sys/drives.nix!"
echo "Simply exit when you are done editing."
nix --extra-experimental-features nix-command shell nixpkgs\#fish .\#nvim --command fish
nixos-install --flake /dotfiles\#nixosConfigurations.$host
echo "Setting user password..."
nixos-enter --root /mnt -c "passwd readf0x"

