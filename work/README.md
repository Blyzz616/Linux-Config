# Domain Checker and Service Status 

## Setup

- Install WSL (Debian)

- Copy the folders under `/usr/` to their locations

- copy `.bashrc`, `.nanorc`, `.screenrc` to your `/home/<usr>/` directory

- Log out and back in again

## Usage

### Service Status Check

On WSL start up it will run the Service Status check. It can also be run with:

> status

### Domain Check

Use the comman `domain` followed by the domain name.

> domain www.blyzz.com

## Updates

Handled automatically

## Known Bugs

If nothing comes up in the domain check for _Registration Date_ or _Last Updated_, You may need to open [Whois](https://whois.com/whois/example.com) to get around the captcha.
