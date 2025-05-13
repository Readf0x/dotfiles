#! /usr/bin/env nix-shell
#! nix-shell -i zsh -p md4c ripgrep bat xdg-utils

function meow() {
  print "\# \[TODO\]";

  # [TODO] Condense items
  items=(${(f)"$(rg '\[TODO\]')"})
  for i in $items; do
    print "$i" | sed 's/^\([a-zA-Z0-9\/\.]*\)/*\1*/' | sed 's/:\s*# /:\n/' | sed 's/\[TODO\]/-/'
    print
  done
}

if [[ $1 == '--html' ]]; then
  meow | md2html -o /tmp/todo.html
  xdg-open /tmp/todo.html
else
  meow | bat -plmd
fi

