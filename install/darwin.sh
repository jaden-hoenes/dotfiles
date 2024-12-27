#!/bin/zsh

echo "Checking Command Line Tools for Xcode"
# Only run if the tools are not installed yet
# To check that try to print the SDK path
xcode-select -p &> /dev/null
if [ $? -ne 0 ]; then
  echo "Command Line Tools for Xcode not found. Installing from softwareupdate…"
# This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
  softwareupdate -i "$PROD" --verbose;
else
  echo "Command Line Tools for Xcode have been installed."
fi

echo "Checking Rosetta"
if [[ "$(sysctl -n machdep.cpu.brand_string)" == *'Apple'* ]]; then
    if arch -x86_64 /usr/bin/true 2> /dev/null; then
      echo "x86_64 programs can be run, skipping"
    else
      echo "x86_64 programs can not be run, installing rosetta"
      softwareupdate --install-rosetta --agree-to-license
    fi
else
  echo "cpu is not an apple cpu, skipping"
fi

echo "Setting up darwin configuration"
nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake ~/.dotfiles/nix#air
