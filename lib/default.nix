{ lib, ... }@inputs: let
  libraries = (builtins.attrNames (lib.filterAttrs (n: v: v == "regular" && n != "default.nix") (builtins.readDir ./.)));
in builtins.foldl'
(a: b: a // b) {}
(lib.zipListsWith (a: b: { ${a} = b; }) (builtins.map
  (i: lib.removeSuffix ".nix" i) libraries) (builtins.map
    (i: import ./../lib/${builtins.toPath "/${i}"} (inputs // { inherit lib; })) libraries))
