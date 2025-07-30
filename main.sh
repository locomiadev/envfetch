#!/bin/sh
RESET="\033[0m"
BOLD_GREEN="\033[1;32m"
BOLD_YELLOW="\033[1;33m"
BOLD_LIGHT_BLUE="\033[1;96m"
BOLD_GENTOO="\033[1;34m"
BOLD_RED="\033[1;31m"
BOLD_GREEN="\033[1;32m"

OS=$( [ -f /etc/os-release ] && . /etc/os-release && echo "$PRETTY_NAME" | tr -d '"' || uname -s )

for arg in "$@"; do
  case "$arg" in
    --distro=*)
      CUSTOM_DISTRO=$(echo "$arg" | cut -d= -f2)
      ;;
  esac
done

if [ -n "$CUSTOM_DISTRO" ]; then
  OS="$CUSTOM_DISTRO"
fi

if [ "$(uname -s)" = "Darwin" ]; then
  USER=$(id -un)
  HOST=$(uname -n)
  TOTAL=$(echo "0") # oops darwin is not FHS
  AVAILABLE=$(echo "0") # oops darwin is not FHS
  USED=$(echo "0") # oops darwin is not FHS
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
    echo "Unknown CPU"
  fi
  )
  SHELL=$(basename "$SHELL")
else
  USER=$(id -un)
  HOST=$(hostname)
  TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
  USED=$((TOTAL - AVAILABLE))
  CPU=$(grep -m 1 'model name' /proc/cpuinfo | cut -d ':' -f2 | sed 's/^ //')
  SHELL=$(basename "$SHELL")
fi

detect_pkg_manager() {
  if command -v pacman >/dev/null 2>&1; then
    echo "pacman"
  elif command -v apt >/dev/null 2>&1; then
    echo "apt"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
  elif command -v zypper >/dev/null 2>&1; then
    echo "zypper"
  elif command -v apk >/dev/null 2>&1; then
    echo "apk"
  elif command -v xbps-install >/dev/null 2>&1; then
    echo "xbps"
  elif command -v pkg >/dev/null 2>&1; then
    echo "pkg"
  else
    echo "unknown"
  fi
}

PKG_MANAGER=$(detect_pkg_manager)

case "$OS" in
  "Void Linux")
    art_color="$BOLD_GREEN"
    ;;
  Locoware\ GNU/Linux*)
    art_color="$BOLD_YELLOW"
    ;;
  "Arch Linux")
    art_color="$BOLD_LIGHT_BLUE"
    ;;
  Alpine\ Linux*)
    art_color="$BOLD_GENTOO"
    ;;
  "Darwin")
    art_color="$RESET"
    ;;
  Fedora\ Linux*)
    art_color="$BOLD_LIGHT_BLUE"
    ;;
  Debian*)
    art_color="$BOLD_RED"
    ;;
  Drauger\ OS*)
    art_color="$BOLD_RED"
    ;;
  Ubuntu*)
    art_color="$BOLD_RED"
    ;;
  Linux\ Mint*)
    art_color="$BOLD_GREEN"
    ;;
  *)
    art_color="$RESET"
    ;;
esac

ascii_art=""
case "$OS" in
  "Void Linux")
    [ -f ascii/void_linux.txt ] && ascii_art=$(cat ascii/void_linux.txt)
    ;;
  Locoware\ GNU/Linux*)
    [ -f ascii/locoware.txt ] && ascii_art=$(cat ascii/locoware.txt)
    ;;
  "Arch Linux")
    [ -f ascii/arch_linux.txt ] && ascii_art=$(cat ascii/arch_linux.txt)
    ;;
  Alpine\ Linux*)
    [ -f ascii/alpine_linux.txt ] && ascii_art=$(cat ascii/alpine_linux.txt)
    ;;
  "Darwin")
    [ -f ascii/apple.txt ] && ascii_art=$(cat ascii/apple.txt)
    ;;
  Fedora\ Linux*)
    [ -f ascii/fedora.txt ] && ascii_art=$(cat ascii/fedora.txt)
    ;;
  Debian*)
    [ -f ascii/debian.txt ] && ascii_art=$(cat ascii/debian.txt)
    ;;
  Drauger\ OS*)
    [ -f ascii/drauger.txt ] && ascii_art=$(cat ascii/drauger.txt)
    ;;
  Ubuntu*)
    [ -f ascii/ubuntu.txt ] && ascii_art=$(cat ascii/ubuntu.txt)
    ;;
  Linux\ Mint*)
    [ -f ascii/mint.txt ] && ascii_art=$(cat ascii/mint.txt)
    ;;
esac

if [ -n "$ascii_art" ]; then
  art_lines=$(echo "$ascii_art")
  
  info_lines="
$USER@$HOST
os: $OS
pkg: $PKG_MANAGER
ram: $((USED / 1024)) / $((TOTAL / 1024)) MiB
cpu: $CPU
shell: $SHELL
envfetch: 2.2.2-r1
"
  i=1
  while [ $i -le 10 ]; do
    art_line=$(echo "$art_lines" | sed -n "${i}p")
    info_line=$(echo "$info_lines" | sed -n "${i}p")
    printf "${art_color}%-15s\t%s${RESET}\n" "$art_line" "$info_line"
    i=$((i + 1))
  done
else
  printf "Wow! Your system doesn't have ASCII art! Tell about this at https://github.com/locomiadev/lfetch\n"
  printf "\n"
  printf "${art_color}user: %s@%s${RESET}\n" "$USER" "$HOST"
  printf "${art_color}os: %s${RESET}\n" "$OS"
  printf "${art_color}pkg: %s${RESET}\n" "$PKG_MANAGER"
  printf "${art_color}ram: %d / %d MiB${RESET}\n" $((USED / 1024)) $((TOTAL / 1024))
  printf "${art_color}cpu: %s${RESET}\n" "$CPU"
  printf "${art_color}shell: %s${RESET}\n" "$SHELL"
  printf "${art_color}envfetch: 2.2.2-r1%s${RESET}\n"
fi