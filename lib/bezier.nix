{ lib, ... }: let
  math = import ./math.nix {inherit lib;};
  lerp = math.lerp;
  abs = math.abs;
in rec {
  bezierCubic = p0: p1: p2: p3: t: let
    p01 = lerp p0 p1 t;
    p12 = lerp p1 p2 t;
    p23 = lerp p2 p3 t;
    p012 = lerp p01 p12 t;
    p123 = lerp p12 p23 t;
  in lerp p012 p123 t;
  over100 = p0: p1: p2: p3: builtins.genList (x: bezierCubic p0 p1 p2 p3 ((x + 1) / 100.0)) 100;
  # TODO: create binary search for X
  # B should be an array of 100 points, being [x y]
  findX = x: b: with builtins; foldl' (a: b: if abs((elemAt a 0) - x) < abs((elemAt b 0) - x) then a else b) [0 0] b;
}
