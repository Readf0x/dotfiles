{ ... }:
  v: if builtins.typeOf v == "string" then v else
    "${if v ? form then "-f ${v.form} " else ""}${v.name}"
