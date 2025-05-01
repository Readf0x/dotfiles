#!/usr/bin/env zsh

function meow() {
  print "\# \[TODO\]"
  rg '\[TODO\]' | sed 's/.*:\s*# //' | sed 's/\[TODO\]/-/'
}

meow | bat -plmd

