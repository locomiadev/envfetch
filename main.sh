#!/bin/sh
clear

RESET="\033[0m"
BOLD_GREEN="\033[1;32m"
BOLD_YELLOW="\033[1;33m"
BOLD_LIGHT_BLUE="\033[1;96m"
BOLD_GENTOO="\033[1;34m"

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

USER=$(id -un)
HOST=$(hostname)
TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
USED=$((TOTAL - AVAILABLE))
CPU=$(grep -m 1 'model name' /proc/cpuinfo | cut -d ':' -f2 | sed 's/^ //')
SHELL=$(basename "$SHELL")

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
  "Alpine Linux")
    art_color="$BOLD_GENTOO"
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
  "Alpine Linux")
    [ -f ascii/alpine_linux.txt ] && ascii_art=$(cat ascii/alpine_linux.txt)
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
envfetch: 1.0
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
  printf "${art_color}envfetch: 1.0%s${RESET}\n"
fi