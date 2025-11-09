{
  fish,
  writeScriptBin
}: writeScriptBin "installer" ''
  #!${fish}/bin/fish
  ${builtins.readFile ./installer.fish}
''
