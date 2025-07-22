let
  config = import ../hosts/config.nix;
  users = { inherit (config.userPubKeys) readf0x; };
  hosts = builtins.mapAttrs (n: v: v.ssh.publicKey) config.config.hosts;
  all = builtins.attrValues (users // hosts);
in {
  "cache-priv-key.age".publicKeys = all;
}
