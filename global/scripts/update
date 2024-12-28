#!/usr/bin/env zsh
author="readf0x"
ver="v2.3.1"

# Formatting codes
reset="\033[0m"
bold="\033[1m"
black="\033[30m"
gray="\033[90m"
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
blue="\033[34m"
magenta="\033[35m"
cyan="\033[36m"
white="\033[37m"

helpers=("paru" "yay" "aura" "pikaur" "aurman" "pacaur" "pakku" "trizen")

debug=false
noconfirm=false
logout="auto"
reboot="auto"
poweroff="auto"

# Logic
time=$(date +%s)

function help() {
  if pacman -Qg nerd-fonts>/dev/null; then
    arch=""
    hypr=""
  fi
  echo "${green}Usage:$reset update [<options>] [<arguments>...]
${green}Full system update$reset
Written for ${blue}$arch Arch Linux$reset & ${cyan}$hypr Hyprland$reset
Supports $bold${green}yay$reset, $bold${green}paru$reset, $bold${green}flatpak$reset, and $bold${green}hyprpm$reset
  ${gray}hyprpm can be finicky, you may need to run it manually
  after restarting your session$reset

${green}Options:$reset
  ${blue}-h$reset, ${blue}--help$reset			Print this message

${green}Installation options:$reset
  ${blue}-y$reset, ${blue}--noconfirm$reset		Skip confirmation prompts
  ${blue}-c$reset, ${blue}--chaotic$reset			Chaotic-AUR mode (requires paru, greedy)
  ${blue}--nodebug$reset			Remove debug symbols

${green}Post-installation options:$reset
  ${blue}-l$reset, ${blue}--logout ${reset}[${red}true$reset|${red}false$reset]	Logout after update
  ${blue}-r$reset, ${blue}--reboot ${reset}[${red}true$reset|${red}false$reset]	Reboot after update
  ${blue}-p$reset, ${blue}--poweroff ${reset}[${red}true$reset|${red}false$reset]	Poweroff after update
${gray}Treated as boolean flag unless argument is provided$reset
${gray}ver.$reset $yellow$ver$reset"
  exit 0
}

# Custom options parser bcs getops and zparseopts both suck
# I miss flatmap :'(
# TODO: Check for conflicting options
function badopt() { echo "Bad option: $bold$red$1$reset"; exit 1 }
lastopt="bad"
for opt in $@; do
  if [[ $opt =~ ^-- ]]; then
    lastopt=$opt
    case $opt in
      --noconfirm)
        noconfirm=true
        ;;
      --logout)
        logout=true
        ;;
      --reboot)
        reboot=true
        ;;
      --poweroff)
        poweroff=true
        ;;
      --help)
        help
        ;;
      --nodebug)
        nodebug=true
        ;;
      --chaotic)
        chaotic=true
        ;;
      --debug)
        debug=true
        ;;
      *)
        badopt $opt
        ;;
    esac
  elif [[ $opt =~ ^- ]]; then
    for char in $(echo ${opt#"-"} | fold -w1); do
      lastopt="-$char"
      case $char in
        y)
          noconfirm=true
          ;;
        l)
          logout=true
          ;;
        r)
          reboot=true
          ;;
        p)
          poweroff=true
          ;;
        h)
          help
          ;;
        c)
          chaotic=true
          ;;
        *)
          badopt "-$char"
          ;;
      esac
    done
  else
    # support for option arguments is pretty easy to add, just track the last option
    # and write a handler for it
    case $lastopt in
      -l|--logout)
        if [[ $opt == "true" ]]; then
          logout=true
        elif [[ $opt == "false" ]]; then
          logout=false
        else
          badopt "$lastopt $opt"
        fi
        ;;
      -r|--reboot)
        if [[ $opt == "true" ]]; then
          reboot=true
        elif [[ $opt == "false" ]]; then
          reboot=false
        else
          badopt "$lastopt $opt"
        fi
        ;;
      -p|--poweroff)
        if [[ $opt == "true" ]]; then
          poweroff=true
        elif [[ $opt == "false" ]]; then
          poweroff=false
        else
          badopt "$lastopt $opt"
        fi
        ;;
      --debug)
        if [[ $opt == "true" ]]; then
          debug=true
        elif [[ $opt == "false" ]]; then
          debug=false
        else
          badopt "$lastopt $opt"
        fi
        ;;
      *)
        badopt $opt
        ;;
    esac
  fi
done

function arrow() {
  printf %${4:-0}s
  if [[ $3 ]]; then
    echo "$bold$1$3$reset $2"
  else
    echo "$bold$1==>$reset $2"
  fi
}

if $debug; then
  local args=("debug,$debug" "noconfirm,$noconfirm" "logout,$logout" "reboot,$reboot" "poweroff,$poweroff")
  arrow $green "${bold}Options:$reset \"$bold$@$reset\"" "::"
  # arrow $gray "${bold}debug$reset=$debug$reset"
  for i in $args; do
    local name=${i%,*}
    local value=${i#*,}
    case $value in
      true) arrow $yellow "${blue}$name$reset=$green$value$reset" "->" 1 ;;
      false) arrow $yellow "${blue}$name$reset=$red$value$reset" "->" 1 ;;
      auto) arrow $yellow "${blue}$name$reset=$gray$value$reset" "->" 1 ;;
      *) arrow $yellow "$bold${red}$name=$value$reset" "->" 1 ;;
    esac
  done
fi

# package manager wrapper
function update() {
  if which $1 > /dev/null; then eval $2; fi
  local ex=$?
  if [[ $ex != 0 ]]; then exit $ex; fi
}
installed_helpers=()
if $debug; then
  installed_helpers=($helpers)
else
  for helper in $helpers; do
    if which $helper > /dev/null; then installed_helpers+=($helper); fi
  done
fi
# TODO: add more helpers
function aur_commands() {
  case $1 in
    paru)
      paru -Syu --devel --needed $(if $2; then echo -n "--noconfirm --sudoloop"; fi)
      ;;
    yay)
      yay -Syu --devel --needed $(if $2; then echo -n "--noconfirm --sudoloop"; fi)
      ;;
  esac
}

if $noconfirm; then
  # I don't have the heart to take this out of the code
  # I spend SO long on it
  # while ! [[ $started ]] || ps aux | grep "yay -Syu --devel --noconfirm" | grep -v grep | grep -vq rg; do
  #   started=true
  #   echo "Refreshing sudo"
  #   sudo -v
  #   sleep 295
  # done &
  aur_commands ${installed_helpers[1]} true
  update 'flatpak' 'flatpak update -y'
else
  # AUR helper selector
  if [[ ${#installed_helpers[@]} > 1 ]]; then
    arrow $green "Aur helper to use?"
    arrow $yellow "Options in red have not been implemented yet" "->" 1

    local line="${cyan}"
    for i in $installed_helpers; do
      case $i in
        paru)
          line+="[P]aru$reset "
          ;;
        yay)
          line+="[Y]ay$reset "
          ;;
        aura)
          line+="${red}[A]ura$reset "
          ;;
        pikaur)
          line+="${red}[I] Pikaur$reset "
          ;;
        aurman)
          line+="${red}[U] Aurman$reset "
          ;;
        pacaur)
          line+="${red}[C] Pacaur$reset "
          ;;
        pakku)
          line+="${red}[K] Pakku$reset "
          ;;
        trizen)
          line+="${red}[T]rizen$reset "
          ;;
      esac
    done

    arrow $green $line
    echo -n "$bold$green==>$reset "
    read -k 1 aur
    if ! [[ $aur == $'\n' ]]; then echo; fi

    case $aur in
      p|P)
        aur_commands paru false
        ;;
      y|Y)
        aur_commands yay false
        ;;
      *)
        aur_commands ${installed_helpers[1]} false
        ;;
    esac
    local ex=$?
    if [[ $ex != 0 ]]; then exit $ex; fi
  else
    aur_commands ${installed_helpers[1]} false
  fi
  if [[ $nodebug ]]; then
    pacman -Qq | grep -e 'debug$' | pacman -R -
  fi
  if [[ $chaotic ]]; then
    pacman -Qq | grep -e '-git$' | paru -Sa -
  fi
  update 'flatpak' 'flatpak update'
fi
update 'hyprpm' 'hyprpm update'

# Takes regex that must match all package names from beginning to end (without ^ or $)
# Returns epoch timestamp of last time package(s) was(were) installed/upgraded
function checkpkg() {
  tac /var/log/pacman.log | awk -v pkg="${1}" '
    /\[ALPM\] (installed|upgraded)/ && $0 ~ pkg {
      match($0, /\[([0-9T:-]+)\]/, date_arr);
      print date_arr[1];
      exit;
    }
  ' | head -1 | xargs -I{} date --date={} +%s
}
# Exact same as checkpkg(), but for hooks intead.
# Hooks *should* always follow the format of XX-hook-name.hook (where X is a digit)
function checkhook() {
  tac /var/log/pacman.log | awk -v pkg="${1}" '
    /\[ALPM\] (running)/ && $0 ~ pkg {
      match($0, /\[([0-9T:-]+)\]/, date_arr);
      print date_arr[1];
      exit;
    }
  ' | head -1 | xargs -I{} date --date={} +%s
}

echo "$bold$green==>$reset ${bold}Post-installation action?"
echo "$bold$green==>$reset ${cyan}[N]othing$reset [L]ogout [R]eboot [P]oweroff"
echo -n "$bold$green==>$reset "
if [[ $noconfirm == false ]] && [[ $logout != true ]] && [[ $reboot != true ]] && [[ $poweroff != true ]]; then
  read -k 1 post
else
  if [[ $poweroff == true ]]; then poweroff
  elif [[ $reboot == true ]]; then reboot
  elif [[ $logout == true ]]; then hyprctl dispatch exit
  elif $noconfirm; then
    if [[ $(checkpkg "linux(-(hardened|lts|rt|rt-lts|zen))?") > $time ]] && [[ $reboot != false ]]; then reboot
    elif [[ $(checkpkg "hyprland(-git)?") > $time ]] && [[ $logout != false ]]; then hyprctl dispatch exit
    fi
  fi
fi
if ! [[ $post == $'\n' ]]; then echo; fi
case $post in
  l|L)
    hyprctl dispatch exit
    ;;
  r|R)
    reboot
    ;;
  p|P)
    poweroff
    ;;
  *)
    exit 0
    ;;
esac

