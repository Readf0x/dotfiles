#!/usr/bin/env zsh

function update() {
  commits=("${(@f)$(nix flake update neoshell 2>&1 | rg -o '[0-9a-f]{40}')}")
  git commit -m 'update quickshell' -m "${commits[1]} -> ${commits[2]}" -m $1
}

if [[ $1 = ('-f'|'--force') ]]; then
  update
fi

if nix flake metadata 2>/dev/null | rg -F "$(nix flake show 'github:readf0x/quickshell' 2>/dev/null | head -n 1 | sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g')"; then
  print "Already up to date"
elif git status --porcelain | grep -q .; then
  update
else
  print "Repo has working changes, actions would commit staged changes and/or could depend on unstaged changes."
  print "Run with -f, --force to run actions anyway."
fi
