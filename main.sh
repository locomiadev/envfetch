#!/bin/sh
CONFDIR="." # You can change this
ASCII_DIR="ascii/" # And this
# Please dont change anything below unless you know what are you doing
if [ -f $CONFDIR/config.sh ]; then
  . $CONFDIR/config.sh
fi
if [ ! -n "$CUSTOMENVFETCHVER" ]; then
  ENVFETCH_VER="3.4.2"
else
  ENVFETCH_VER="$CUSTOMENVFETCHVER"
fi
RESET="\033[0m"
BOLD_ORANGE="\033[1;172m"
BOLD_PURPLE="\033[1;35m"
BOLD_GREEN="\033[1;32m"
BOLD_YELLOW="\033[1;33m"
BOLD_LIGHT_BLUE="\033[1;96m"
BOLD_GENTOO="\033[1;34m"
BOLD_RED="\033[1;31m"
BOLD_AQ="\033[1;36m"
BOLD_WHITE="\033[1;37m"
# Android /system/bin/sh support
# (not for termux)
if [ "$SHELL" = "/system/bin/sh" ]; then
	# This is a part of The QNU Project
	# QNU libmaing.sh (Version 1.0)
	# https://github.com/qnuproject
	# https://qnu.locomia.xyz

	mai () {
		for maingonment in $@; do
			case $maingonment in
				*[0-9]*) echo "$maingonment" && return ;;
			esac
		done
	}
	# The libmaing was inserted to this script for more environmentator.
	ANDROIDTOTALMB=$(mai $(grep MemTotal /proc/meminfo))
	if grep -q MemAvailable /proc/meminfo; then
		ANDROIDAVAIL=$(mai $(grep MemAvailable /proc/meminfo))
	else
		ANDROIDAVAIL=$(mai $(grep MemFree /proc/meminfo))
	fi
	ANDROIDUSED=$((ANDROIDTOTALMB - ANDROIDAVAIL))

echo "               	        "
echo "$BOLD_GREEN  ;,           ,;    $USER@$HOSTNAME         "
echo "   :;,.-----.,;:     os:       Android $(getprop ro.build.version.release)"
echo "  ,:           :,    pkg:      pm ($(pm list packages | grep -c '^' ))"
echo " /    O     O    \   cpu:      $(getprop ro.hardware) "
echo "|                 |  shell:    $SHELL             "
echo "'-----------------'  ram:      $((ANDROIDUSED / 1024)) / $((ANDROIDTOTALMB / 1024)) MiB"
echo "                     phone:    $(getprop ro.product.brand) $(getprop ro.product.model)"
echo "                     envfetch: $ENVFETCH_VER $RESET"
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
  M*_NT-10.*) OS="Windows 10" ;;
  M*_NT-11.*) OS="Windows 11" ;;
  M*_NT-*)    OS="Unknown Windows" ;;
  Haiku)           OS="Haiku OS" ;;
  *)               OS=$( [ -f /etc/os-release ] && . /etc/os-release && echo "$PRETTY_NAME" | tr -d '"' || echo "$UNAME_S" ) ;;
esac
case "$UNAME_O" in
  Android)  OS="Android" ;;
  FreeBSD)  OS="FreeBSD" ;;
esac
if [ -f /etc/redstar-release ]; then
  OS="Red Star OS"
fi
for arg in "$@"; do
  case "$arg" in
    --distro=*) CUSTOM_DISTRO=$(echo "$arg" | cut -d= -f2) ;;
  esac
done

[ -n "${CUSTOM_DISTRO:-}" ] && OS="$CUSTOM_DISTRO"
[ -n "${CUSTOMOS:-}" ] && OS="$CUSTOMOS"

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
    echo "Apple A16 Bionic"
  elif [ "$(uname -m)" = "iPhone16,1" ]; then # iphone 15 pro
    echo "Apple A17 Pro"
  elif [ "$(uname -m)" = "iPhone16,2" ]; then # iphone 15 pro max
    echo "Apple A17 Pro"
  elif [ "$(uname -m)" = "iPhone17,1" ]; then # iphone 16 pro
    echo "Apple A18"
  elif [ "$(uname -m)" = "iPhone17,2" ]; then # iphone 16 pro max
    echo "Apple A18"
  elif [ "$(uname -m)" = "iPhone17,3" ]; then # iphone 16
    echo "Apple A18"
  elif [ "$(uname -m)" = "iPhone17,4" ]; then # iphone 16 plus
    echo "Apple A18"
  elif [ "$(uname -m)" = "iPhone17,5" ]; then # iphone 16e
    echo "Apple A18"
  elif [ "$(uname -m)" = "iPhone18,1" ]; then # iphone 17 pro
    echo "Apple A19"
  elif [ "$(uname -m)" = "iPhone18,2" ]; then # iphone 17 pro max
    echo "Apple A19"
  elif [ "$(uname -m)" = "iPhone18,3" ]; then # iphone 17
    echo "Apple A19"
  elif [ "$(uname -m)" = "iPhone18,4" ]; then # iphone air
    echo "Apple A19"
  elif [ -n "$CUSTOMCPU" ]; then # custom cpu
    echo "$CUSTOMCPU"
  else
    echo "Unknown CPU" # Apple device with unknown for fetch CPU
  fi
  )
  SHELL=$(basename "$SHELL")
  AGE="$(date -j -f "%b %d %Y" "Jan 1 2024" +%s)"
elif [ "$(uname -s)" = "Haiku" ]; then
  USER="${CUSTOMUSER:-$(id -un)}"
  HOST="${CUSTOMHOST:-$(uname -n)}"
  TOTAL="${CUSTOMMEM_TOTAL:-0}"
  AVAILABLE="${CUSTOMMEM_AVAIL:-0}"
  USED="${CUSTOMMEM_USED:-0}"
  CPU="${CUSTOMCPU:-$(sysinfo -cpu | awk -F '\"' '/CPU #0/ {print $2}')}"
  SHELL="${CUSTOMSHELL:-$(basename "$SHELL")}"
elif [ "$(uname -o)" = "Android" ]; then
  USER="${CUSTOMUSER:-$(id -un)}"
  HOST="${CUSTOMHOST:-$(uname -n)}"
  TOTAL="${CUSTOMMEM_TOTAL:-$(grep MemTotal /proc/meminfo | awk '{print $2}')}"
  AVAILABLE="${CUSTOMMEM_AVAIL:-$(grep MemFree /proc/meminfo | awk '{print $2}')}"
  USED="${CUSTOMMEM_USED:-$((TOTAL - AVAILABLE))}"
  CPU="${CUSTOMCPU:-$(grep -m 1 'Hardware' /proc/cpuinfo | cut -d ':' -f2 | sed 's/^ //')}"
  SHELL="${CUSTOMSHELL:-$(basename "$SHELL")}"
  SHELL=$(basename "$SHELL")
elif [ "$OS" = "Red Star OS" ]; then
  USER="${CUSTOMUSER:-$(id -un)}"
  HOST="${CUSTOMHOST:-$(uname -n)}"
  TOTAL="${CUSTOMMEM_TOTAL:-$(grep MemTotal /proc/meminfo | awk '{print $2}')}"
  AVAILABLE="${CUSTOMMEM_AVAIL:-$(grep MemFree /proc/meminfo | awk '{print $2}')}"
  USED="${CUSTOMMEM_USED:-$((TOTAL - AVAILABLE))}"
  CPU="${CUSTOMCPU:-$(grep -m 1 'model name' /proc/cpuinfo | cut -d ':' -f2 | sed 's/^ //')}"
  SHELL="${CUSTOMSHELL:-$(basename "$SHELL")}"
elif [ "$(uname -o)" = "FreeBSD" ]; then
  USER="${CUSTOMUSER:-$(id -un)}"
  HOST="${CUSTOMHOST:-$(hostname)}"
  TOTAL="${CUSTOMMEM_TOTAL:-$(sysctl -n hw.physmem)}"
  PAGE_SIZE="$(sysctl -n hw.pagesize 2>/dev/null || echo 4096)"
  AVAILABLE="${CUSTOMMEM_AVAIL:-$(( $(sysctl -n vm.stats.vm.v_free_count || echo 0) * PAGE_SIZE ))}"
  USED="${CUSTOMMEM_USED:-$((TOTAL - AVAILABLE))}"
  CPU="${CUSTOMCPU:-$(sysctl -n hw.model 2>/dev/null)}"
  SHELL="${CUSTOMSHELL:-$(basename "$SHELL")}"
else
  USER="${CUSTOMUSER:-$(id -un)}"
  HOST="${CUSTOMHOST:-$(uname -n)}"
  TOTAL="${CUSTOMMEM_TOTAL:-$(grep MemTotal /proc/meminfo | awk '{print $2}')}"
  AVAILABLE="${CUSTOMMEM_AVAIL:-$(grep MemAvailable /proc/meminfo | awk '{print $2}')}"
  USED="${CUSTOMMEM_USED:-$((TOTAL - AVAILABLE))}"
  CPU="${CUSTOMCPU:-$(grep -m 1 'model name' /proc/cpuinfo | cut -d ':' -f2 | sed 's/^ //')}"
  SHELL="${CUSTOMSHELL:-$(basename "$SHELL")}"
fi
detect_init() {
	if command -v systemctl >/dev/null 2>&1; then
		echo "systemd v$(systemctl --version | head -n 1 | awk '{print $2}')"
	elif command -v rc-service >/dev/null 2>&1; then
		echo "OpenRC v$(rc-service --version | awk '{print $3}')"
	else
		echo "$(ps -p 1 -o comm=)"
	fi
}
detect_pkg_manager() {
  if command -v pacman >/dev/null 2>&1; then
    echo "pacman [$(pacman -Qq | wc -l)]"
  elif command -v apt >/dev/null 2>&1; then
    echo "apt [$(dpkg --get-selections | grep -v deinstall | wc -l)]"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf [$(rpm -qa | wc -l)]"
  elif command -v zypper >/dev/null 2>&1; then
    echo "zypper [$(rpm -qa | wc -l)]"
  elif command -v apk >/dev/null 2>&1; then
    echo "apk [$(grep -c '^P:' /lib/apk/db/installed)]"
  elif command -v xbps-install >/dev/null 2>&1; then
    echo "xbps [$(xbps-query -l | wc -l)]"
  elif command -v pkg >/dev/null 2>&1; then
    if [ "$(uname -o)" = "FreeBSD" ]; then
      echo "pkg [$(pkg query -a '%n' | wc -l | tr -d ' ')]"
    elif [ "$(uname -s)" = "Darwin" ]; then
      echo "pkg [$(pkg list | wc -l | tr -d ' ')]"
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
    echo "prt-get [$(pkginfo -i | wc -l)]"
  elif command -v eopkg >/dev/null 2>&1; then
    echo "eopkg [$(eopkg li | wc -l)]"
  else
    echo "unknown"
  fi
}
if [ -n "$CUSTOMPKG" ]; then
  PKG_MANAGER="$CUSTOMPKG"
elif [ -n "$CUSTOMPKGCOUNT" ]; then
  PKG_MANAGER="$CUSTOMPKG [$CUSTOMPKGCOUNT]"
else
  PKG_MANAGER=$(detect_pkg_manager)
fi

if [ -n "$CUSTOMINIT" ]; then
  ENVINIT="$CUSTOMINIT"
elif [ -n "$CUSTOMINITVER" ]; then
  ENVINIT="$CUSTOMINIT $CUSTOMINITVER"
else
  ENVINIT="$(detect_init)"
fi
art_name=""
art_color="$RESET"

case "$OS" in
  "Void Linux") 	art_color="$BOLD_GREEN"; 	art_name="void_linux" ;;
  Locoware\ GNU/Linux*) art_color="$BOLD_YELLOW"; 	art_name="locoware" ;;
  "Arch Linux") 	art_color="$BOLD_LIGHT_BLUE"; 	art_name="arch_linux" ;;
  Alpine\ Linux*) 	art_color="$BOLD_GENTOO"; 	art_name="alpine_linux" ;;
  "Darwin") 		art_color="$RESET"; 		art_name="apple" ;;
  Fedora\ Linux*) 	art_color="$BOLD_LIGHT_BLUE"; 	art_name="fedora" ;;
  Debian*) 		art_color="$BOLD_RED"; 		art_name="debian" ;;
  Drauger\ OS*) 	art_color="$BOLD_RED"; 		art_name="drauger" ;;
  Ubuntu*) 		art_color="$BOLD_RED"; 		art_name="ubuntu" ;;
  Linux\ Mint*) 	art_color="$BOLD_GREEN"; 	art_name="mint" ;;
  NixOS*) 		art_color="$BOLD_LIGHT_BLUE"; 	art_name="nixos" ;;
  "Windows 10") 	art_color="$BOLD_GENTOO"; 	art_name="win10" ;;
  "Windows 11" | "Unknown Windows") art_color="$BOLD_GENTOO"; art_name="win11" ;;
  Cachy\ OS*) 		art_color="$BOLD_GREEN"; 	art_name="cachy" ;;
  Devuan\ GNU/Linux*) 	art_color="$BOLD_GENTOO"; 	art_name="devuan" ;;
  Haiku\ OS) 		art_color="$BOLD_LIGHT_BLUE"; 	art_name="haiku" ;;
  Hues\ OS*) 		art_color="$BOLD_RED"; 		art_name="hues" ;;
  Artix*) 		art_color="$BOLD_LIGHT_BLUE"; 	art_name="artix" ;;
  Slackware*) 		art_color="$BOLD_GENTOO"; 	art_name="slackware" ;;
  Pop!_OS*) 		art_color="$BOLD_AQ"; 		art_name="popos" ;;
  Android) 		art_color="$BOLD_GREEN"; 	art_name="android" ;;
  Red\ Star\ OS) 	art_color="$BOLD_RED"; 		art_name="redstaros" ;;
  FreeBSD*) 		art_color="$BOLD_RED"; 		art_name="freebsd" ;;
  CRUX*) 		art_color="$BOLD_GENTOO"; 	art_name="crux" ;;
  postmarketOS*) 	art_color="$BOLD_GREEN"; 	art_name="postmarketos" ;;
  openSUSE*) 		art_color="$BOLD_GREEN"; 	art_name="suse" ;;
  UniqueOS*)    	art_color="$BOLD_RED";  	art_name="crux" ;;
  Solus*)		art_color="$BOLD_GENTOO";	art_name="solus" ;;
  [Ee]ndeavour*)	art_color="$BOLD_PURPLE";   	art_name="endeavour" ;;
  MX*)			art_color="$BOLD_WHITE";	art_name="mx" ;;

  *)  art_color="";  art_name="crux" ;;
esac
environmentingonment() {
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
	    
      if pgrep -x xfce4-session >/dev/null 2>&1; then echo "xfce (auto-detected)"
      elif pgrep -x gnome-session >/dev/null 2>&1; then echo "gnome (auto-detected)"
      elif pgrep -x kdeinit5 >/dev/null 2>&1; then echo "kde (auto-detected)"
      elif pgrep -x lxsession >/dev/null 2>&1; then echo "lxde (auto-detected)"
      elif pgrep -x mate-session >/dev/null 2>&1; then echo "mate (auto-detected)"
      elif pgrep -x sway >/dev/null 2>&1; then echo "sway (auto-detected)"
      elif pgrep -x hyprland >/dev/null 2>&1; then echo "hyprland (auto-detected)"
      elif pgrep -x dwm >/dev/null 2>&1; then echo "dwm (auto-detected)"
      elif pgrep -x twm >/dev/null 2>&1; then echo "twm (auto-detected)"
      else echo "Unknown"; fi
    fi
  fi
}
# SQ Wipro Footbal Word CUp
# S.A.C Klimer and ischaenn lock
# Environmentingonment stacking up and twanking up fix the lixic the hixic nixic go hixic the STACK GOD
DE=$(environmentingonment)
[ -n "$CUSTOMENV" ] && DE="$CUSTOMENV"

ascii_art=""
if [ -n "$CUSTOMASCIIART" ]; then
  art_name="$CUSTOMASCIIART"
fi
[ -f "${ASCII_DIR}/${art_name}.txt" ] && ascii_art=$(cat "${ASCII_DIR}/${art_name}.txt")

if [ -n "$ascii_art" ]; then
  art_lines="$ascii_art"
  info_lines="
$USER@$HOST
os:       $OS
pkg:      $PKG_MANAGER
ram:      $((USED / 1024)) / $((TOTAL / 1024)) MiB
cpu:      $CPU
init:     $ENVINIT
shell:    $SHELL
de/wm: 	  $DE
envfetch: $ENVFETCH_VER
"

  i=1
  while [ $i -le 10 ]; do
    art_line=$(echo "$art_lines" | sed -n "${i}p")
    info_line=$(echo "$info_lines" | sed -n "${i}p")
    printf "${art_color}%-15s\t${RESET}%s${RESET}\n" "$art_line" "$info_line"   
    i=$((i + 1))
  done
fi

