# kittygo


## Description

Installing Go packages can be a hassle sometimes for those who just want to quickly install packages and get going. Kittygo is a Bash script that serves as a straightforward workaround for those who want a headache-free experience when installing Go tools. Simply install them and get to work. 

##How It Works
Kittygo utilizes `go install -v` for Go package installation and subsequently copies the resulting file from GOPATH to /usr/bin. It's as straightforward as that.

Kittygo also provides the following functionalities:

* Removal of Go packages
* Listing of installed Go packages

You have the option to set your pre-defined GOPATH as well.

## Requirements

1. Go version latest or >1.17.
2. If running as portable, ensure this script has execute permissions. Use `chmod +x ./kittygo.sh` to grant permissions.

## Usage

### Installation

git clone this repository:
```
git clone https://github.com/yannawr/kittygo && cd kittygo
```

No installation is necessary, but if you find it more convenient, you can use the following command:

```bash
./kittygo.sh --install-kittygo
```

This will copy the script to /usr/local/bin/ and create a configuration file. Then you can then delete the repository directory if you prefer.

If you're running as a portable script though, make sure you have execute permissions.

### Installing a Go Package

To install a Go package, use the following command:

```bash
sudo kittygo -i <repository_URL>
```

Replace `<repository_URL>` with the URL of the Go package you want to install.

Examples:

```bash
sudo kittygo -i github.com/tomnomnom/anew@latest
sudo kittygo -i https://github.com/tomnomnom/waybackurls
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
sudo kittygo -l
```

### Setting Custom GOPATH

You can set a custom GOPATH using the following command:

```bash
sudo kittygo -p <your/go/path>
```

This won't change the GOPATH on your system, only in the kittygo settings.

### Restoring Default GOPATH

If you want to restore the default GOPATH to `/root/go/bin`, use the following command:

```bash
sudo kittygo -d
```
This won't change the GOPATH on your system, only in the kittygo settings.

### Removing kittygo

If you want to remove kittygo, use the following command:

```bash
sudo kittygo --remove-kittygo
```

## Notes

- When running as `./kittygo.sh`, make sure the script has execute permissions.
- kittygo uses a configuration file to manage the GOPATH. You can customize the configuration by editing the `config.conf` file.
- Feel free to join in and contribute!
