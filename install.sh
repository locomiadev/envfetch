tesl() {
  echo "[envfetch installer] $@"
}

[ -z $ENVFETCH_DIR ] && ENVFETCH_DIR=/usr/lib/envfetch
[ -z $ENVFETCH_BIN ] && ENVFETCH_BIN=/usr/bin/envfetch

SUDO=
if [ -w $(realpath $(dirname $ENVFETCH_DIR)) ] && \
  ([ -w $(realpath $(dirname $ENVFETCH_BIN)) ] || \
  [ $(realpath $(dirname $ENVFETCH_BIN)) = $(realpath $ENVFETCH_DIR) ]); then SUDO=""
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
  tesl "run with writable ENVFETCH_DIR and ENVFETCH_BIN vars so you can install"
  tesl "your env: no sudo/doas/pkexec dude thats crazzy"
  exit 1
fi

case "$1" in
  install)
  	tesl "install envspygornemt.."

    $SUDO install -D ascii/* -t $ENVFETCH_DIR/ascii
    $SUDO install -m777 main.sh $ENVFETCH_DIR/envfetch
    $SUDO mkdir -p $(dirname $ENVFETCH_BIN)
    $SUDO sh -c "echo 'cd $(realpath $ENVFETCH_DIR); ./envfetch' > $ENVFETCH_BIN"
    $SUDO chmod +x $ENVFETCH_BIN

    tesl "successfully envneted! use envfetch with envfetch command"
     	
  	exit 0
	;;
  uninstall)
  	tesl "uninstall envspygornemt.."

    $SUDO rm -r $ENVFETCH_DIR $ENVFETCH_BIN
    
    tesl "successfully uninstatlled.."
  	
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
