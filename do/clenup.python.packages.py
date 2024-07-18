#!/bin/bash

# List of necessary packages to keep
necessary_packages=(
  "pip"
)

# Get list of all installed packages
installed_packages=$(pip freeze | awk -F'==' '{print $1}')

# Uninstall packages that are not in the necessary_packages list
for package in $installed_packages; do
  if [[ ! " ${necessary_packages[@]} " =~ " ${package} " ]]; then
    echo "Uninstalling $package..."
    pip uninstall -y $package
  fi
done

echo "Cleanup complete. Only necessary packages are retained."
