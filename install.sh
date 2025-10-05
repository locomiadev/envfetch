tesl() {
  echo "[envfetch installer] $@"
}

SUDO=
if [ "$EUID" = 0 ]; then SUDO=""
elif command -v sudo > /dev/null; then SUDO="sudo ";
elif command -v doas > /dev/null; then SUDO="doas ";
elif command -v pkexec > /dev/null; then SUDO="pkexec ";
else
  tesl "NO ROOT/SUDO COMMAND!!!!"
  tesl "f*ck! BROJEN ENV"
  tesl
  tesl "   _____ "
  tesl "  < die >"
  tesl "   ----- "
  tesl "          \\   ^__^"
  tesl "           \\  (oo)\\_______"
  tesl "              (__)\\       )\\/\\"
  tesl "                  ||----w |"
  tesl "                  ||     ||"
  tesl
  tesl "run as root to install or if you are run with EUID=0"
  tesl "your env: no sudo/doas/pkexec dude thats crazzy"
  exit 1
fi

case "$1" in
  install)
  	tesl "install envspygornemt.."

    $SUDO install -D ascii/* -t /usr/lib/envfetch/ascii
    $SUDO install -m777 main.sh /usr/lib/envfetch/envfetch
    $SUDO ln -s /usr/lib/envfetch/envfetch /usr/bin/envfetch
     	
  	exit 0
	;;
  uninstall)
  	tesl "uninstall envspygornemt.."

    $SUDO rm -r /usr/lib/envfetch /usr/bin/envfetch
  	
  	exit 0
  ;;
esac

tesl
echo "welcome to the installer"
echo "if you want to install envfetch:       ./install.sh install"
echo "if you want to remove envfetch:        ./install.sh uninstall"
echo ""
echo "envfetch installer v2.0 | locomia (c) 2025 | https://github.com/locomiadev"
exit 1
