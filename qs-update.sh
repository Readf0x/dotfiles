#!/usr/bin/env zsh

commit=$(cat flake.lock | jq -r '.nodes.neoshell.locked.rev')
latest=$(curl 'https://api.github.com/repos/readf0x/quickshell/commits?per_page=1' 2>/dev/null | jq '.[].sha' -r)

function update() {
  nix flake update neoshell
  git add flake.lock
  git commit -m 'update quickshell' -m "${commit:0:7} -> ${latest:0:7}"
}

if [[ $commit = $latest ]]; then
  print "Already up to date"
else
  update
fi
