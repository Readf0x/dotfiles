#!/usr/bin/env zsh

if [[ $1 == -h ]] || [[ $1 == --help ]]; then
  msg="$(sed -e 's/^[ ]*| //m' <<'--------------------'
    | A script for upgrading this flake
    | 
    | %UUsage:%u %Bupgrade.sh%b [ARGS]
    | 
    | %UArguments:%u
    |   %B-c%b\tClean up store after upgrading (useful for low storage systems)
--------------------
    )"
  print -P $msg
else
  if [[ $(git rev-list $(git config checkout.defaultRemote)/$(git branch --show-current 2>/dev/null) --not HEAD --count) == '0' ]]; then
    nix flake update && \
    ./switch.sh && \
    if [[ $1 == "-c" ]]; then
      ./global/scripts/nix-clean
    fi
  else
    print "Repo is not up to date."
  fi
fi

