for arg in "$@"; do
  case "$arg" in
    -rm)
	    echo "[envfetch installer] do you want to delete everything in this directory? (y/n): "
	    read wow
	    if [ "$wow" = "y" ]; then
		echo "[envfetch installer] cleaning directory..."
	    	rm -rvf ./*
		echo "[envfetch installer] removed"
		exit 0
	    elif [ "$wow" = "n" ]; then
		echo "[envfetch installer] closing installer..."
		exit 0
	    else
		echo "[envfetch installer] not an y/n: closing installer..."
		exit 1
	    fi
      ;;
    -rmbin)
	    echo "[envfetch installer] do you want to delete installed envfetch? (y/n): "
	    read wow2
	    if [ "$wow2" = "y" ]; then
		echo "[envfetch installer] removing envfetch..."
                rm -rvf /bin/envfetch.d
		echo "[envfetch installer] removed"
		exit 0
	    elif [ "$wow2" = "n" ]; then
		echo "[envfetch installer] closing installer..."
		exit 0
	    else
		echo "[envfetch installer] not an y/n: closing installer..."
		exit 1
	    fi
      ;;
    -install)
	    echo "[envfetch installer] preparing for the installation..."
	    if [ -d /bin/envfetch.d ]; then
		    echo "preparing: failed: already installed"
		    exit 1
	    else
		    echo "preparing: 30%"
	    fi
	    if [ -f main.sh ]; then
		    echo "preparing: 60%"
	    else
		    echo "preparing: failed: no main.sh in this directory"
	    fi
	    if [ -d ascii ]; then
		   echo "preparing: 100%"
	    else
		   echo "preparing: failed: no ascii directory"
	    fi
	    echo "[envfetch installer] prepared successfully"
	    echo "[envfetch installer] do you want to install envfetch? (y/n): "
	    read wow3
	    if [ "$wow3" = "y" ]; then
		    echo "[envfetch installer] proceeding with installing"
	    elif [ "$wow3" = "n" ]; then
		    echo "[envfetch installer] stopping the installing process..."
		    exit 0
	    else
		    echo "[envfetch installer] not an y/n: stopping the installing process..."
		    exit 1
	    fi
	    echo "[envfetch installer] checking for the root rights..."
	    if [ "$(id -u)" != 0 ]; then 
		    echo "[envfetch installer] start from the root user!"
		    exit 1
	    fi
	    echo "[envfetch installer] checked successfully"
	    echo "[envfetch installer] checking for the /bin directory..."
	    if [ -d /bin ]; then
		    echo "[envfetch installer] checked successfully"
	    else
		    echo "[envfetch installer] not FHS system/doesn't have /bin directory!"
		    exit 1
	    fi
	    echo "[envfetch installer] checked successfully!"
	    echo "[envfetch installer] making the /bin/envfetch.d directory..."
	    mkdir /bin/envfetch.d || {
	    	echo "[envfetch installer] error with making /bin/envfetch.d directory! aborting the installing process..."
	    	exit 1
	    }
	    echo "[envfetch installer] maked successfully!"
	    echo "[envfetch installer] copying the main.sh file to /bin/envfetch.d"
	    cp main.sh /bin/envfetch.d/main.sh || {
	    	echo "[envfetch installer] error with copying main.sh to /bin/envfetch.d directory! aborting the installing process..."
	    exit 1
	    }
	    echo "[envfetch installer] successfully copied main.sh -> /bin/envfetch.d!"
	    cp -r ascii /bin/envfetch.d/ascii || {
	    	echo "[envfetch installer] error with copying ascii to /bin/envfetch.d directory! aborting the installing process..."
	    exit 1
	    }
	    echo "[envfetch installer] successfully copied ascii -> /bin/envfetch.d!"
	    echo "[envfetch installer] successfully installed!"
	    if [ "$SHELL" = "/bin/bash" ]; then
		    echo "[envfetch installer] adding an alias to ~/.bashrc (for envfetch)"
		    echo "[envfetch installer] checking for ~/.bashrc..."
		    if [ -f ~/.bashrc ]; then
			echo "alias envfetch='cd /bin/envfetch.d;./main.sh;cd - > /dev/null'" >> ~/.bashrc  # alias from meexreay thanks
			echo "[envfetch installer] added an alias into ~/.bashrc successfully!"
		    else
			echo "[envfetch installer] you use BASH but doesn't have ~/.bashrc: alias isn't added"
		    fi
	    else
                    echo "[envfetch installer] you don't use BASH: add string alias envfetch='cd /bin/envfetch.d;./main.sh;cd - > /dev/null' into your shell config yourself!"
	    fi
	    echo ""
	    echo "[envfetch installer] installed envfetch successfully!"
	    exit 0
	;;
  esac
done

echo "[envfetch installer]"
echo "welcome to the installer"
echo "if you want to install envfetch:       ./install.sh -install"
echo "if you want to remove envfetch:        ./install.sh -rmbin"
echo "if you want to clean this directory:   ./install.sh -rm"
echo ""
echo "envfetch installer v1.3 | locomia (c) 2025 | https://github.com/locomiadev"
