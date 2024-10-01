{ lib, conf }: rec {
  getId = num: builtins.elemAt conf.monitors (
    if num >= lib.length conf.monitors
    then (lib.length conf.monitors - 1)
    else num
  );
  access = list: index: builtins.toString (builtins.elemAt list index);
  toRes = x: "${access x 0}x${access x 1}";
  map = lib.forEach conf.monitors;
}
