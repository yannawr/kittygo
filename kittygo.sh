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
# Version: 1.0
# Creation: 2023-10-26
# Author: yannawr
# Repository: github.com/yannawr/kittygo
#
# This script installs Go packages and copies the resulting binary to /usr/bin/
# It also uninstalls Go packages by removing the files from Go path and /usr/bin/
# 
# Requirements:
# 1. Go version latest or >1.17.
# 2. If running as portable, ensure this script has execute permissions. Use 'chmod +x ./kittygo.sh' to grant permissions.

MSG_ALERT="\e[31mError: Invalid usage of arguments. Please enter --help or -h to view the available commands.\e[0m"

script_dir=$(dirname "$0")

if [ "$0" == "/usr/local/bin/kittygo" ]; then
    if [ -f "/etc/kittygo/config.conf" ]; then
        source "/etc/kittygo/config.conf"
    else

        if [ ! -d "/etc/kittygo" ]; then
            mkdir -p "/etc/kittygo"
        fi
        echo -e "# config.conf\nGOPATH=/root/go/bin/" > /etc/kittygo/config.conf
    fi
elif [ -f "$script_dir/config.conf" ]; then
    source "$script_dir/config.conf"
else
    echo -e "# config.conf\nGOPATH=/root/go/bin/" > $script_dir/config.conf
fi

show_help() {
    echo "Welcome to kittygo!"
    echo ""
    echo "Options:"
    echo ""
    echo "-d, --default-path                                   Restore Go path to /root/go/bin/."
    echo "-h, --help                                           Display available commands."
    echo "-i <repository_URL>, --install <repository_URL>      Install a Go package."
    echo "-ik, --install-kittygo                               Install kittygo."
    echo "-l, --list                                           Display Go packages already installed."
    echo "-p <your/go/path>, --path <your/go/path>             Set Go path."
    echo "-r <tool_name>, --remove <tool_name>                 Remove a Go package."
    echo "-rk, --remove-kittygo                                Remove kittygo installation."
}

show_list() {
    if [ -z "$(ls -A $GOPATH)" ]; then
        echo "No installed packages found."
        exit 0
    else    
        ls $GOPATH
        exit 0
    fi
}

install_kittygo() {
    cp kittygo.sh /usr/local/bin/kittygo
    chmod +x /usr/local/bin/kittygo

    if [ -f "$script_dir/config.conf" ]; then
        if [ ! -d "/etc/kittygo" ]; then
            mkdir -p "/etc/kittygo"
        fi
        cp $script_dir/config.conf /etc/kittygo/config.conf
    else 
        if [ ! -d "/etc/kittygo" ]; then
            mkdir -p "/etc/kittygo"
        fi
        echo -e "# config.conf\nGOPATH=/root/go/bin/" > /etc/kittygo/config.conf
    fi

    if [ -f "/usr/local/bin/kittygo" ] && [ -x "/usr/local/bin/kittygo" ] && [ -f "/etc/kittygo/config.conf" ]; then
        echo "kittygo has been successfully installed."
    else
        echo -e "\e[31mError: kittygo was not successfully installed.\e[0m"
        remove_kittygo
    fi
}

remove_kittygo() {
    rm -r /usr/local/bin/kittygo
    rm -r /etc/kittygo/
    echo "kittygo has been successfully removed."
}

install_package() {
    echo "Running: go install -v $REPOSITORY_URL"
    if go install -v "$REPOSITORY_URL"; then
        echo -e "\e[1;32mInstallation successful.\e[0m"
    else
        echo -e "\e[31mInstallation Failed.\e[0m"
        exit 1
    fi

    echo "Copying $GOPATH$REPOSITORY_NAME to /usr/bin/"
    if cp "$GOPATH$REPOSITORY_NAME" /usr/bin/; then
        echo -e "\e[1;32mCopy successful.\e[0m"
    else
        echo -e "\e[31mCopy Failed.\e[0m"
        exit 1
    fi
}

remove_package() {
    echo "Removing $PACKAGE_PATH"
    if rm -r $PACKAGE_PATH; then
        echo -e "\e[1;32mRemoval successful.\e[0m"
    else
        echo -e "\e[31mFailed to Remove\e[0m"
        exit 1
    fi

    echo "Removing $USRBIN_PATH"
    if [ ! -e "$USRBIN_PATH" ]; then
        echo "No action was required for the '$REPOSITORY_NAME' package in /usr/bin/ as it was not located in the path."
        exit 1
    elif rm -r $USRBIN_PATH; then
        echo -e "\e[1;32mRemoval successful.\e[0m"
    else
        echo -e "\e[31mFailed to Remove\e[0m"
        exit 1
    fi

    exit 0
}

restore_path() {
    DEFAULT_PATH="/root/go/bin"
    if [ -n "$script_dir" ] && [ "$script_dir" != "." ]; then
        sed -i "s/^GOPATH=.*$/GOPATH=\"$DEFAULT_PATH\"/" "$script_dir/config.conf"
    elif [ $script_dir = "/usr/local/bin/kittygo" ]; then
        sed -i "s/^GOPATH=.*$/GOPATH=\"$DEFAULT_PATH\"/" "/etc/kittygo/config.conf"
    else
        sed -i "s/^GOPATH=.*$/GOPATH=\"$DEFAULT_PATH\"/" "config.conf"
    fi
    echo "Go path restored to: $DEFAULT_PATH"    
}

set_GOPATH() {
    if [ -n "$script_dir" ] && [ "$script_dir" != "." ]; then
        sed -i "s/^GOPATH=.*$/GOPATH=\"$USER_GOPATH\"/" "$script_dir/config.conf"
    elif [ $script_dir = "/usr/local/bin/kittygo" ]; then
        sed -i "s/^GOPATH=.*$/GOPATH=\"$USER_GOPATH\"/" "/etc/kittygo/config.conf"
    else
        sed -i "s/^GOPATH=.*$/GOPATH=\"$USER_GOPATH\"/" "config.conf"
    fi
    echo "Go path updated to: $USER_GOPATH. Ensure the path is correct or it may incur errors."
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
            exit 0
            ;;
        "--install-kittygo" | "-ik")
            if [ -d "/usr/local/bin/kittygo" ]; then
                echo "kittygo is already installed."
                exit 0
            else
                install_kittygo
                exit 0
            fi
            ;;
        "--remove-kittygo" | "-rk")
            if [ ! -f "/usr/local/bin/kittygo" ] || [ ! -d "/etc/kittygo" ]; then
                echo "kittygo is not installed."
                exit 0
            else
                remove_kittygo
                exit 0
            fi
            ;;
    esac
fi

##################################

if [ "$#" -eq 2 ]; then
    case "$1" in
        "--install" | "-i")
            REPOSITORY_CLEAN_URL=$(echo "$2" | sed 's/^https:\/\///' | awk -F'@' '{print $1}')
            REPOSITORY_URL="$REPOSITORY_CLEAN_URL@latest"
            REPOSITORY_NAME=$(echo "$REPOSITORY_CLEAN_URL" | rev | cut -d'/' -f1 | rev)
            install_package
            exit 0
            ;;
        "--remove" | "-r")
            REPOSITORY_NAME="$2"
            PACKAGE_PATH="$GOPATH$REPOSITORY_NAME"
            USRBIN_PATH="/usr/bin/$REPOSITORY_NAME"

            if [ ! -e "$PACKAGE_PATH" ]; then
                echo "Package '$REPOSITORY_NAME' was not found."
                exit 1
            fi

            if [[ "$PACKAGE_PATH" == */bin || "$PACKAGE_PATH" == */bin/ || "$USRBIN_PATH" == */bin || "$USRBIN_PATH" == */bin/ ]]; then
                echo -e "\e[31mThe operation cannot be completed due to a folder-related error.\e[0m"
                exit 1
            fi
            remove_package
            exit 0
            ;;
        "--path" | "-p")
            USER_GOPATH="$2"
            set_GOPATH
            exit 0
            ;;
    esac
fi

echo -e "$MSG_ALERT"
exit 1
