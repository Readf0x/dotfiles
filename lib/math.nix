{ lib, ... }: rec {
  convert = list: builtins.foldl' (a: b: a // b) {} (lib.zipListsWith (a: b: { ${a} = b; }) ["x" "y"] list);
  lerp = a: b: t: builtins.attrValues (builtins.mapAttrs (i: ai: ai + ((convert b).${i} - ai) * t) (convert a));
  abs = n: if n < 0 then -n else n;
}
