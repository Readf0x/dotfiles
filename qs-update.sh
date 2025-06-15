#!/usr/bin/env zsh

metadata=$(nix flake metadata 2>&1 | rg -oe 'github:readf0x\/quickshell\/[^\?]*')
commit=${metadata#'github:readf0x/quickshell/'}
latest=$(curl 'https://api.github.com/repos/readf0x/quickshell/commits?per_page=1' 2>/dev/null | jq '.[].sha' -r)

function update() {
  nix flake update neoshell
  git add flake.lock
  git commit -m 'update quickshell' -m "${commit:0:7} -> ${latest:0:7}"
}

if [[ $1 = ('-f'|'--force') ]]; then
  update
  exit
fi

if [[ $commit = $latest ]]; then
  print "Already up to date"
elif ! git status --porcelain | rg -q .; then
  update
else
  print "Repo has working changes, actions would commit staged changes and/or could depend on unstaged changes."
  print "Run with -f, --force to run actions anyway."
fi
