#!/usr/bin/env zsh

SUB=()
if ! [[ $HOSTNAME = "Loki-IV" ]] && ping loki4 -w 1 2>&1 >/dev/null; then
  SUB+='http://loki4:5000'
elif ! [[ $HOSTNAME = "Loki-II" ]] && ping loki2 -w 1 2>&1 >/dev/null; then
  SUB+='http://loki2:5000'
fi

if [[ ${#SUB} > 0 ]]; then
  nh os switch . -- --option substituters "$SUB" $@
  nh home switch . -- --option substituters "$SUB" $@
else
  nh os switch . -- $@
  nh home switch . -- $@
fi

