#!/bin/bash
# 
# .         .  .                
# |      o _|__|_               
# |.-.   .  |  |  .  . .-.. .-. 
# |-.'   |  |  |  |  |(   |(   )
# '  `--' `-`-'`-'`--| `-`| `-' 
#                    ; ._.'     
#                 `-'      
# kittygo
# Version: 3.0.0
# Creation: 2023-10-26
# Author: yannawr
# Repository: github.com/yannawr/kittygo
#
# This script installs Go packages and moves the resulting binary to /usr/bin/go-packages
# 
# Requirements:
# 1. Go version latest or >1.17.
# 2. If running as portable, ensure this script has execute permissions. Use 'chmod +x ./kittygo.sh' to grant permissions.


script_dir=$(dirname "$0")

default_go_path="/root/go/bin/"
kittygo_go="/usr/bin/go-packages/"
kittygo_install="/usr/local/bin/"
kittygo_installed="/usr/local/bin/kittygo"
kittygo_conf_installation="/etc/kittygo/"
kittygo_conf_installed="/etc/kittygo/config.conf"


colour(){
	if [ $# -lt 2 ]; then
		exit 1
	fi	
	case "$1" in
		"success")
			printf "\033[01;32m$2\033[0m\n"
			;;
		"error")
			printf "\033[01;31m$2\033[0m\n"
			;;
		*)
			return 1
			;;
	esac
}

if [ "$0" == "$kittygo_installed" ]; then
    if [ -f "$kittygo_conf_installed" ]; then
        source "$kittygo_conf_installed"
    else

        if [ ! -d "$kittygo_conf_installation" ]; then
            mkdir -p "$kittygo_conf_installation"
        fi
        echo -e "# config.conf\nGOPATH=\"$default_go_path\"" > \"$kittygo_conf_installed\"
    fi
elif [ -f "$script_dir/config.conf" ]; then
    source "$script_dir/config.conf"
else
    echo -e "# config.conf\nGOPATH=\"$default_go_path\"" > $script_dir/config.conf
fi

show_help() {
    echo "Welcome to kittygo!"
    echo ""
    echo "Options:"
    echo ""
    echo "-d, --default-path                                   Restore GOPATH to /root/go/bin/."
    echo "-h, --help                                           Print this help."
    echo "-i <repository_url>, --install <repository_url>      Install a Go package."
    echo "-I, --install-kittygo                                Install kittygo."
    echo "-l, --list                                           Display Go packages already installed."
    echo "-p </your/go/path/>, --path </your/go/path/>             Set your GOPATH. Enter the entire path." 
    echo "                                                     Example: /home/$USER/go/bin/." 
    echo "                                                     Ensure it ends with /"
    echo "-r <tool_name>, --remove <tool_name>                 Remove a Go package."
    echo "-R, --remove-kittygo                                 Remove kittygo installation."
}

show_list() {
    if [ $(ls $kittygo_go | wc -l) -eq 0 ]; then
        echo "No installed packages found."
    else
        ls $kittygo_go
    fi
}

install_kittygo() {
    
    cp kittygo.sh "$kittygo_installed"
    chmod +x "$kittygo_installed"

    if [ -f "$script_dir/config.conf" ]; then
        if [ ! -d "$kittygo_conf_installation" ]; then
            mkdir -p "$kittygo_conf_installation"
        fi
        cp $script_dir/config.conf "$kittygo_conf_installed"
    else 
        if [ ! -d "$kittygo_conf_installation" ]; then
            mkdir -p "$kittygo_conf_installation"
        fi
        
        echo -e "# config.conf\nGOPATH=\"$default_go_path\"" > "$kittygo_conf_installed"
    fi

    if [ ! -d $kittygo_go ]; then
        mkdir $kittygo_go
    fi

    if [ -f "$kittygo_installed" ] && [ -x "$kittygo_installed" ] && [ -f "$kittygo_conf_installed" ] && [ -d $kittygo_go ]; then
        colour success "kittygo has been successfully installed."
        if ! grep -q "export PATH=\$PATH:$kittygo_go" /home/$SUDO_USER/.bashrc; then
            echo "export PATH=\$PATH:$kittygo_go" >> /home/$SUDO_USER/.bashrc
        fi
    else
        colour error "Error: kittygo was not successfully installed."
        remove_kittygo
        exit 1
    fi

    if grep -q "export PATH=\$PATH:$kittygo_go" /home/$SUDO_USER/.bashrc; then
        colour success "Path successfully added to ~/.bashrc."
    else
        colour error "Error: Path could not be set in ~/.bashrc. You need to manually add '$kittygo_go' to path."
    fi
}

remove_kittygo() {
    rm -r "$kittygo_installed"
    rm -r "$kittygo_conf_installation"
    sed -i "\#export PATH=\$PATH:$kittygo_go#d" /home/$SUDO_USER/.bashrc

    if grep -q 'export PATH=\$PATH:$kittygo_go' /home/$SUDO_USER/.bashrc; then
        colour error "Error: The path could not be removed from ~/.bashrc."
    fi

    if [ -d $kittygo_go ]; then
        echo "kittygo will not remove packages when uninstalling. If you want to uninstall go packages, delete the folder: $kittygo_go"
    fi

    if [ -f "$kittygo_conf_installed" ]; then
        colour error "Error: config.conf is still in the directory."
    fi
  
    if [ -f "$kittygo_instaled" ]; then
        colour error "Error: kittygo could not be successfully removed."
        exit 1
    fi

    echo "kittygo was successfully removed."

}

install_package() {
    echo "Running: go install -v $repository_url"
    if go install -v "$repository_url"; then
        colour success "Installation successful."
    else
        colour error "Installation Failed."
        exit 1
    fi

    echo "Moving $GOPATH$repository_name to $kittygo_go"
    if cp "$GOPATH$repository_name" "$kittygo_go"/; then
        colour success "Package moved successfully."
    else
        colour error "Package could not be moved."
        exit 1
    fi

}

remove_package() {
    echo "Removing $usrbin_path"
    if rm -r $usrbin_path; then
        colour success "Removal successful."
    else
        colour error "Failed to Remove."
        exit 1
    fi

}

restore_path() {
    if [ "$script_dir/" = "$kittygo_install" ]; then
        if sed -i "s|^GOPATH=.*$|GOPATH=\"$default_go_path\"|" "$kittygo_conf_installed"; then
            colour success "Go path restored to: $default_go_path"
            exit 0
        fi
    else
        if sed -i "s|^GOPATH=.*$|GOPATH=\"$default_go_path\"|" "config.conf"; then
            colour success "Go path restored to: $default_go_path"
            exit 0
        fi 
    fi

    colour error "Error: Path could not be changed."
    exit 1
   
}

set_GOPATH() {
    if [ "$script_dir/" = "$kittygo_install" ]; then
        if sed -i "s|^GOPATH=.*$|GOPATH=\"$USER_GOPATH\"|" "$kittygo_conf_installed"; then
            colour success "Go path updated to: $USER_GOPATH. Ensure the path is correct or it may incur errors."
            exit 0
        fi
    else
        if sed -i "s|^GOPATH=.*$|GOPATH=\"$USER_GOPATH\"|" "config.conf"; then
            colour success "Go path updated to: $USER_GOPATH. Ensure the path is correct or it may incur errors."
            exit 0
        fi             
    fi
    colour error "Error: Path could not be changed."
    exit 1
}

##################################

if [ "$#" -eq 1 ]; then
    case "$1" in
        "--help" | "-h")
            show_help
            exit 0
            ;;
        "--list" | "-l")
            show_list
            exit 0
            ;;
        "--default-path" | "-d")
            restore_path
            ;;
        "--install-kittygo" | "-I")
            if [ -d "$kittygo_installed" ]; then
                echo "kittygo is already installed."
                exit 0
            else
                install_kittygo
                exit 0
            fi
            ;;
        "--remove-kittygo" | "-R")
            if [ ! -f "$kittygo_installed" ] || [ ! -d "$kittygo_conf_installation" ]; then
                echo "kittygo is not installed."
                exit 0
            else
                remove_kittygo
                exit 0
            fi
            ;;
        *)
            echo "Invalid argument usage. Please See --help."
            exit 1
            ;;
    esac
fi

##################################

if [ "$#" -eq 2 ]; then
    case "$1" in
        "--install" | "-i")
            repository_clean_url=$(echo "$2" | sed 's/^https:\/\///' | awk -F'@' '{print $1}')
            repository_url="$repository_clean_url@latest"
            repository_name=$(echo "$repository_clean_url" | rev | cut -d'/' -f1 | rev)
            install_package
            exit 0
            ;;
        "--remove" | "-r")
            repository_name="$2"

            usrbin_path="$kittygo_go$repository_name"

            if [ ! -e "$usrbin_path" ]; then
                echo "Package '$repository_name' was not found."
                exit 0
            fi

            if [[ "$usrbin_path" == */bin || "$usrbin_path" == */bin/ ]]; then
                colour error "The operation cannot be completed due to a folder-related error."
                exit 1
            fi
            remove_package
            exit 0
            ;;
        "--path" | "-p")
            USER_GOPATH="$2"
            set_GOPATH
            ;;
        *)
            echo "Invalid argument usage. Please See --help."
            exit 1
            ;;
    esac
fi

colour error "An unexpected error occurred."
exit 1
