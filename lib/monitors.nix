{ lib, conf, ... }: rec {
  getId = num: builtins.elemAt conf.monitors (
    if num >= lib.length conf.monitors
    then (lib.length conf.monitors - 1)
    else num
  );
  access = list: index: toString (builtins.elemAt list index);
  toRes = x: "${access x 0}x${access x 1}";
  toRes' = x: y: "${(builtins.elemAt x 0) / y |> toString}x${(builtins.elemAt x 1) / y |> toString}";
  map = lib.forEach conf.monitors;
}
