# kittygo


## Description

Kittygo is a Bash script that serves as a straightforward workaround for installing Go packages in the directory you specify.

## How It Works

Kittygo utilizes `go install -v` for Go package installation and subsequently moves the resulting file from GOPATH to /usr/bin/go-packages or to the directory you specify. It's as straightforward as that.

Kittygo also provides the following functionalities:

* Removal of Go packages
* Listing of installed Go packages

You have the option to set your pre-defined GOPATH as well.

This is a script for those who have trouble setting a GOPATH and just want to install Go packages without worrying too much about other issues, so it's a workaround.

## Requirements

1. Go version latest or >1.17.
2. That's all!

## Usage

### Installation

git clone this repository:
```
git clone https://github.com/yannawr/kittygo && cd kittygo && sudo chmod +x ./kittygo.sh
```
Set the PATH to `/usr/bin/go-packages/` in your shell.
You may need to close the terminal and reopen it for the installed packages to be usable from the command line, or run `source ~/.bashrc`. 
If packages still doesn't work, it means you need to set the USERPATH kittygo defined as follows: `export PATH=$PATH:/usr/bin/go-packages/`.

No installation is necessary, but if you find it more convenient, you can use the following command:

```bash
sudo ./kittygo.sh --install-kittygo
```

This will copy the script to /usr/local/bin/ (default) and create a configuration file. Then you can delete the repository directory if you prefer.

### Installing a Go Package

To install a Go package, use the following command:

```bash
kittygo -i <repository_URL>
```

Replace `<repository_URL>` with the URL of the Go package you want to install.

Examples:

```bash
kittygo -i github.com/tomnomnom/anew@latest
kittygo -i https://github.com/tomnomnom/waybackurls
```

### Removing a Go Package

To remove a Go package, use the following command:

```bash
sudo kittygo -r <package_name>
```

Example: 

```bash
sudo kittygo --remove anew
```

### Listing Installed Packages

To list the Go packages already installed, use the following command:

```bash
kittygo -l
```

Example:

```
kittygo --list

Searching for files.

airixss
amass
assetfinder
cariddi
cf-check
chaos
dalfox
filter-resolved
freq
gargs
gau
getJS
gf
goop
gospider
hakrawler
packer
waybackurls

```

### Setting Custom GOPATH and USERPATH

You can set a custom GOPATH using the following command:

```bash
sudo kittygo --set-gopath </your/go/path/>
```
This won't change the GOPATH on your system, only in the kittygo settings. You must set the entire path and it must end with a "/" as in the example.

```bash
sudo kittygo --set-gopath /home/$USER/go/home/
```

USERPATH is the new location you want packages to be installed. You can set a custom USERPATH using the following command:

```bash
sudo kittygo --set-userpath </your/userpath/path/>
```
You also must set the entire path and it must end with a "/" as in the example.

### Removing kittygo

If you want to remove kittygo, use the following command:

```bash
sudo kittygo --remove-kittygo
```
That's it