#!/usr/bin/env bash

# Don't ignore errors. Exit immediately of one comes up instead.
set -e

# Define a help function
Help()
{
    echo "Rebuild the target of choice: Either a NixOS host or HomeManager home."
    echo
    echo "Usage: rebuild.sh {host | home} [flake] [-h]"
    echo
    echo "Options"
    echo "h     Print this Help."
    echo
}

# Handle the options
while getopts ":h" option; do
    case $option in
        h)
            Help
            exit;;
        \?)
            echo "Error: Invalid option"
            Help
            exit;;
    esac
done

# Handle argument errors

# Do stuff
case $1 in
    "host")
        case $2 in
            "")
                echo "Flake not specified. Inferring from system."
                flake=$(hostname)
                ;;
            *)
                flake=$2
        esac
        echo "NixOS building flake $flake..."
        sudo nixos-rebuild switch --flake ".#$flake"
        # &>rebuild.log || (
        #     grep error --color rebuild.log && false
        # )
        gen=$(nixos-rebuild list-generations | grep current)
        ;;

    "home")
        case $2 in
            "")
                echo "Flake not specified. Inferring from system."
                host=$(hostname)
                user=$USER
                flake="$user@$host"
                ;;
            *)
                flake=$2
                ;;
        esac
        echo "HomeManager building flake $flake..."
        home-manager switch --flake ".#$flake"
        # &>rebuild.log || (
        #     cat rebuild.log && false
        # )
        gen=$(home-manager generations | head -n 1)
        ;;

    "")
        echo "Error: Invalid target"
        Help
        exit;;
    \?)
        echo "Error: Invalid target"
        Help
        exit;;
esac
# Show diff and commit
git diff --minimal #-U0
git commit -am "$gen"
