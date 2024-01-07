#!/bin/bash

# Function to check if a package is installed
is_installed() {
  command -v "$1" >/dev/null 2>&1
}

# Function to prompt for installation options
prompt_for_install() {
  read -p "Do you want to install it now? (y/n): " yn
  case $yn in
    [Yy]* ) install_package "$1" "$2";;
    [Nn]* ) echo "Skipping installation of $1.";;
    * ) echo "Invalid input. Please enter 'y' or 'n'."; prompt_for_install "$1" "$2";;
  esac
}

# Function to install a package
install_package() {
  if [[ -z "$2" ]]; then
    # Install latest version
    sudo apt install -y "$1"
  else
    # Install specific version
    sudo apt install -y "$1=$2"
  fi
}

# Function to uninstall a package
uninstall_package() {
  sudo apt remove -y "$1"
}

# Install PHP
if is_installed php; then
  read -p "PHP is already installed. Do you want to uninstall it? (y/n): " yn
  if [[ $yn == [Yy]* ]]; then
    uninstall_package php
    prompt_for_install php
  fi
else
  read -p "Which version of PHP do you want to install? (Enter 'latest' for the latest version or a specific version number): " php_version
  prompt_for_install php "$php_version"
fi

# Install Node
if is_installed node; then
  read -p "Node is already installed. Do you want to uninstall it? (y/n): " yn
  if [[ $yn == [Yy]* ]]; then
    uninstall_package node
    prompt_for_install node
  fi
else
  read -p "Which version of Node do you want to install? (Enter 'latest' for the latest version or a specific version number): " node_version
  prompt_for_install node "$node_version"
fi

# Install NVM
if is_installed nvm; then
  read -p "NVM is already installed. Do you want to uninstall it? (y/n): " yn
  if [[ $yn == [Yy]* ]]; then
    nvm uninstall --lts
    prompt_for_install nvm
  fi
else
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
fi

# Install MySQL
if is_installed mysql; then
  read -p "MySQL is already installed. Do you want to uninstall it? (y/n): " yn
  if [[ $yn == [Yy]* ]]; then
    uninstall_package mysql-server
    prompt_for_install mysql-server
  fi
else
  prompt_for_install mysql-server
fi

# Install MongoDB
if is_installed mongo; then
  read -p "MongoDB is already installed. Do you want to uninstall it? (y/n): " yn
  if [[ $yn == [Yy]* ]]; then
    uninstall_package mongodb
    prompt_for_install mongodb
  fi
else
  prompt_for_install mongodb
fi

