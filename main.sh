#!/bin/sh
ENVFETCH_VER="2.3.1"

RESET="\033[0m"
BOLD_GREEN="\033[1;32m"
BOLD_YELLOW="\033[1;33m"
BOLD_LIGHT_BLUE="\033[1;96m"
BOLD_GENTOO="\033[1;34m"
BOLD_RED="\033[1;31m"
BOLD_AQ="\033[1;36m"
# Android /system/bin/sh support
# (not for termux)
if [ "$SHELL" = "/system/bin/sh" ]; then
echo "               	        "
echo "$BOLD_GREEN  ;,           ,;    $USER@$HOSTNAME         "
echo "   :;,.-----.,;:     os: Android $(getprop ro.build.version.release)             "
echo "  ,:           :,    pkg: Google Play             "
echo " /    O     O    \   cpu: $(getprop ro.hardware) "
echo "|                 |  shell: sh             "
echo "'-----------------'  envfetch: $ENVFETCH_VER $RESET"
exit 0
fi
# Diana & other Illumos support
if [ -f /etc/release ]; then
  case "$(cat /etc/release | tr -d '\n' | tr -d ' ')" in
    *OpenIndiana*)
      echo
      echo '      --  /   ' "$(id -un)"@"$(hostname)"
      echo '     /  \ |   ' os: OpenIndiana
      echo '    .\__/ |`| ' pkg: pkg["$(pkginfo | wc -l | tr -d ' ')"]
      echo '    \_____,/  ' cpu: "$(kstat -p cpu_info:0:*:brand | awk -F'\t' '{print $2}')"
      echo '              ' shell: "$(basename "$SHELL")"
      echo '              ' envfetch: $ENVFETCH_VER
      echo
      exit 0
      ;;
      *)
      echo "Oops! You have unsupported Illumos system. Write to the https://github.com/locomiadev/envfetch"
      ;;
  esac
fi
UNAME_S=$(uname -s)
UNAME_O=$(uname -o)
case "$UNAME_S" in
  MINGW64_NT-10.*)
    OS="Windows 10" # if $ is MINGE_NT-10... :: Write Windows 10
    ;;
  MINGW64_NT-11.*)
    OS="Windows 11" # also for Windows 11
    ;;
  MINGW64_NT-*)
    OS="Unknown Windows" # If not recognized windows
    ;;
  Haiku)
    OS="Haiku OS" # for haikuos
    ;;
  *)
    # shellcheck disable=SC1091
    OS=$( [ -f /etc/os-release ] && . /etc/os-release && echo "$PRETTY_NAME" | tr -d '"' || echo "$UNAME_S" ) # If not windows name from /etc/os-release :; else from uname s
    ;;
esac
case "$UNAME_O" in
  Android)
    OS="Android"
    ;;
  FreeBSD)
    OS="FreeBSD"
    ;;
esac
if [ -f /etc/redstar-release ]; then
  OS="Red Star OS"
fi
for arg in "$@"; do
  case "$arg" in
    --distro=*)
      CUSTOM_DISTRO=$(echo "$arg" | cut -d= -f2) # --distro arg support
      ;;
  esac
done

if [ -n "$CUSTOM_DISTRO" ]; then
  OS="$CUSTOM_DISTRO" # if --distro do os = --distro valueing
fi

if [ "$(uname -s)" = "Darwin" ]; then # Apple iPhone supporting. Tesled on non-jailbroken iPhone 12 Pro (iOS 18.5) in a-Shell
  USER=$(id -un)
  HOST=$(uname -n)
  TOTAL="0" # oops darwin is not FHS
  AVAILABLE="0" # oops darwin is not FHS
  USED="0" # oops darwin is not FHS
  CPU=$(if [ "$(uname -m)" = "iPhone13,3" ]; then # my iphone 12 pro
    echo "Apple A14 Bionic"
  elif [ "$(uname -m)" = "iPhone13,4" ]; then # iphone 12 pro max
    echo "Apple A14 Bionic"
  elif [ "$(uname -m)" = "iPhone14,2" ]; then # iphone 13 pro
    echo "Apple A15 Bionic"
  elif [ "$(uname -m)" = "iPhone14,3" ]; then # iphone 13 pro max
    echo "Apple A15 Bionic"
  elif [ "$(uname -m)" = "iPhone14,4" ]; then # iphone 13 mini
    echo "Apple A15 Bionic"
  elif [ "$(uname -m)" = "iPhone14,5" ]; then # iphone 13
    echo "Apple A15 Bionic"
  elif [ "$(uname -m)" = "iPhone14,6" ]; then # iphone se 2022
    echo "Apple A15 Bionic"
  elif [ "$(uname -m)" = "iPhone14,7" ]; then # iphone 14
    echo "Apple A15 Bionic"
  elif [ "$(uname -m)" = "iPhone14,8" ]; then # iphone 14 plus
    echo "Apple A15 Bionic"
  elif [ "$(uname -m)" = "iPhone15,2" ]; then # iphone 14 pro
    echo "Apple A16 Bionic"
  elif [ "$(uname -m)" = "iPhone15,3" ]; then # iphone 14 pro max
    echo "Apple A16 Bionic"
  elif [ "$(uname -m)" = "iPhone15,4" ]; then # iphone 15
    echo "Apple A16 Bionic"
  elif [ "$(uname -m)" = "iPhone15,5" ]; then # iphone 15 plus
    echo "Apple A16 Bionic" # позже добавлю еще
  else
    echo "Unknown CPU" # Apple device with unknown for fetch CPU
  fi
  )
  SHELL=$(basename "$SHELL")
elif [ "$(uname -s)" = "Haiku" ]; then # Haiku OS support
  USER=$(id -un)
  HOST=$(uname -n)
  TOTAL="0" # WIP
  AVAILABLE="0"
  USED="0"
  CPU=$(sysinfo -cpu | awk -F '\\"' '/CPU #0/ {print $2}')
  SHELL=$(basename "$SHELL")
elif [ "$(uname -o)" = "Android" ]; then
  USER=$(id -un)
  HOST=$(uname -n)
  TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  AVAILABLE=$(grep MemFree /proc/meminfo | awk '{print $2}')
  USED=$((TOTAL - AVAILABLE))
  CPU=$(grep -m 1 'Hardware' /proc/cpuinfo | cut -d ':' -f2 | sed 's/^ //')
  SHELL=$(basename "$SHELL")
elif [ "$OS" = "Red Star OS" ]; then
  USER=$(id -un)
  HOST=$(uname -n)
  TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  AVAILABLE=$(grep MemFree /proc/meminfo | awk '{print $2}')
  USED=$((TOTAL - AVAILABLE))
  CPU=$(grep -m 1 'model name' /proc/cpuinfo | cut -d ':' -f2 | sed 's/^ //')
  SHELL=$(basename "$SHELL")
elif [ "$(uname -o)" = "FreeBSD" ]; then
  USER=$(id -un)
  HOST=$(hostname)
  TOTAL=$(sysctl -n hw.physmem)
  AVAILABLE=$(sysctl -n vm.stats.vm.v_free_count)
  PAGE_SIZE=$(sysctl -n hw.pagesize)
  AVAILABLE=$((AVAILABLE * PAGE_SIZE))
  USED=$((TOTAL - AVAILABLE))
  CPU=$(sysctl -n hw.model)
  SHELL=$(basename "$SHELL")
else # For basic Linux/Windows(Mingw64) os
  USER=$(id -un)
  HOST=$(hostname)
  TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
  USED=$((TOTAL - AVAILABLE))
  CPU=$(grep -m 1 'model name' /proc/cpuinfo | cut -d ':' -f2 | sed 's/^ //')
  SHELL=$(basename "$SHELL")
fi

detect_pkg_manager() { #pkg MANAGING ENVIRONMENTINGONMENT DETECTING IF ELSE IF ELSE S.A.C
  # pkg manager count temporarily only for apt, in 2.3 will be fully developed
  if command -v pacman >/dev/null 2>&1; then
    echo "pacman [$(pacman -Qq | wc -l)]"
  elif command -v apt >/dev/null 2>&1; then
    echo "apt [$(dpkg --get-selections | grep -v deinstall | wc -l)]"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf [$(rpm -qa | wc -l)]"
  elif command -v zypper >/dev/null 2>&1; then
    echo "zypper"
  elif command -v apk >/dev/null 2>&1; then
    echo "apk [$(grep -c '^P:' /lib/apk/db/installed)]"
  elif command -v xbps-install >/dev/null 2>&1; then
    echo "xbps [$(xbps-query -l | wc -l)]"
  elif command -v pkg >/dev/null 2>&1; then
    if [ "$(uname -o)" = "FreeBSD" ]; then
      echo "pkg [$(pkg query -a '%n' | wc -l | tr -d ' ')]"
    else
      echo "pkg"
    fi
  elif command -v nix >/dev/null 2>&1; then
    echo "nix"
  elif command -v scoop >/dev/null 2>&1; then
    echo "scoop"
  elif command -v pkgman >/dev/null 2>&1; then
    echo "pkgman"
  elif command -v pkgtool >/dev/null 2>&1; then
    echo "pkgtool"
  elif command -v yum >/dev/null 2>&1; then
    echo "yum [$(rpm -qa | wc -l)]"
  elif command -v emerge >/dev/null 2>&1; then
    echo "emerge [$(qlist -I | wc -l)]"
  elif command -v prt-get >/dev/null 2>&1; then
    echo "prt-get [$(pkginfo | wc -l | tr -d ' ')]"
  else
    echo "unknown"
  fi
}

PKG_MANAGER=$(detect_pkg_manager)

art_name=""
art_color="$RESET"

case "$OS" in # if $OS is something do color & art ~
  "Void Linux")
    art_color="$BOLD_GREEN"
    art_name="void_linux"
    ;;
  Locoware\ GNU/Linux*)
    art_color="$BOLD_YELLOW"
    art_name="locoware"
    ;;
  "Arch Linux")
    art_color="$BOLD_LIGHT_BLUE"
    art_name="arch_linux"
    ;;
  Alpine\ Linux*)
    art_color="$BOLD_GENTOO"
    art_name="alpine_linux"
    ;;
  "Darwin")
    art_color="$RESET"
    art_name="apple"
    ;;
  Fedora\ Linux*)
    art_color="$BOLD_LIGHT_BLUE"
    art_name="fedora"
    ;;
  Debian*)
    art_color="$BOLD_RED"
    art_name="debian"
    ;;
  Drauger\ OS*)
    art_color="$BOLD_RED"
    art_name="drauger"
    ;;
  Ubuntu*)
    art_color="$BOLD_RED"
    art_name="ubuntu"
    ;;
  Linux\ Mint*)
    art_color="$BOLD_GREEN"
    art_name="mint"
    ;;
  NixOS*)
    art_color="$BOLD_LIGHT_BLUE"
    art_name="nixos"
    ;;
  "Windows 10")
    art_color="$BOLD_GENTOO"
    art_name="win10"
    ;;
  "Windows 11" | "Unknown Windows")
    art_color="$BOLD_GENTOO"
    art_name="win11"
    ;;
  Cachy\ OS*)
    art_color="$BOLD_GREEN"
    art_name="cachy"
    ;;
  Devuan\ GNU/Linux*)
    art_color="$BOLD_GENTOO"
    art_name="devuan"
    ;;
  Haiku\ OS)
    art_color="$BOLD_LIGHT_BLUE"
    art_name="haiku"
    ;;
  Hues\ OS*)
    art_color="$BOLD_RED"
    art_name="hues"
    ;;
  Artix*)
    art_color="$BOLD_LIGHT_BLUE"
    art_name="artix"
    ;;
  Slackware*)
    art_color="$BOLD_GENTOO"
    art_name="slackware"
    ;;
  Pop!_OS*)
    art_color="$BOLD_AQ"
    art_name="popos"
    ;;
  Android)
    art_color="$BOLD_GREEN"
    art_name="android"
    ;;
  Red\ Star\ OS)
    art_color="$BOLD_RED"
	art_name="redstaros"
	  ;;
  FreeBSD*)
    art_color="$BOLD_RED"
    art_name="freebsd"
    ;;
  CRUX*)
    art_color="$BOLD_GENTOO"
    art_name="crux"
    ;;
esac

environmentingonment() { #DE/WM detect
  if [ "$(uname -s)" = "Darwin" ]; then
    echo "Aqua"
  elif echo "$OS" | grep -q "Windows"; then
    echo "Explorer"
  else
    if [ -n "$XDG_CURRENT_DESKTOP" ]; then
      echo "$XDG_CURRENT_DESKTOP"
    elif [ -n "$DESKTOP_SESSION" ]; then
      echo "$DESKTOP_SESSION"
    else
      if pgrep -x xfce4-session >/dev/null 2>&1; then
	      echo "xfce (auto-detected)"
      elif pgrep -x gnome-session >/dev/null 2>&1; then
	      echo "gnome (auto-detected)"
      elif pgrep -x kdeinit5 >/dev/null 2>&1; then
	      echo "the k desktop environment (auto-detected)"
      elif pgrep -x lxsession >/dev/null 2>&1; then
	      echo "lxde (auto-detected)"
      elif pgrep -x mate-session >/dev/null 2>&1; then
	      echo "mate (auto-detected)"
      elif pgrep -x sway >/dev/null 2>&1; then
	      echo "sway (auto-detected)"
      elif pgrep -x hyprland >/dev/null 2>&1; then
	      echo "hyprland (auto-detected)"
      elif pgrep -x dwm >/dev/null 2>&1; then
        echo "dwm (auto-detected)"
      else
        echo "Unknown"
      fi
    fi
  fi
}

DE=$(environmentingonment)


ascii_art=""

[ -f ascii/${art_name}.txt ] && ascii_art=$(cat ascii/${art_name}.txt)

if [ -n "$ascii_art" ]; then
  art_lines="$ascii_art"
  
  info_lines="
$USER@$HOST
os: $OS
pkg: $PKG_MANAGER
ram: $((USED / 1024)) / $((TOTAL / 1024)) MiB
cpu: $CPU
shell: $SHELL
de/wm: $DE
envfetch: $ENVFETCH_VER
"
  i=1
  while [ $i -le 10 ]; do
    art_line=$(echo "$art_lines" | sed -n "${i}p")
    info_line=$(echo "$info_lines" | sed -n "${i}p")
    printf "${art_color}%-15s\t%s${RESET}\n" "$art_line" "$info_line"
    i=$((i + 1))
  done
else
  printf "Wow! Your system doesn't have ASCII art! Tell about this at https://github.com/locomiadev/envfetch\n"
  printf "\n"
  printf "   ${art_color}user: %s@%s${RESET}\n" "$USER" "$HOST"
  printf "   ${art_color}os: %s${RESET}\n" "$OS"
  printf "   ${art_color}pkg: %s${RESET}\n" "$PKG_MANAGER"
  printf "   ${art_color}ram: %d / %d MiB${RESET}\n" $((USED / 1024)) $((TOTAL / 1024))
  printf "   ${art_color}cpu: %s${RESET}\n" "$CPU"
  printf "   ${art_color}shell: %s${RESET}\n" "$SHELL"
  printf "   ${art_color}de/wm: %s${RESET}\n" "$DE"
  printf "   ${art_color}envfetch: ${ENVFETCH_VER}%s${RESET}\n"
fi
