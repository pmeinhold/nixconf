#!/usr/bin/env bash
# nixp.sh: Wrapper script for nix-portable with predefined environment variables

export NP_LOCATION=/srv/public/opt-008545/pmeinhold
export NP_RUNTIME=bwrap
export XDG_CACHE_HOME="$NP_LOCATION"/.cache

# Run nix-portable with all arguments passed to this script
exec "$NP_LOCATION/nix-portable" "$@"

# Get the directory where this script is located
#SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ./nixp.sh nix develop --command bash -c "export XDG_CACHE_HOME=$NP_LOCATION/.cache && home-manager switch --flake .#pmeinhold@opt-008545.zib.de"
# set -gx PATH ~/.nix-profile/bin $PATH
#
# READ TO GET A BETTER CONFIG:
# https://github.com/nix-community/home-manager/issues/3752#issuecomment-1566179742
#
# Enable existing nix/home-manager environment/profile:
# ./nixp.sh nix-shell -p fish --command "fish -C 'set -gx PATH ~/.nix-profile/bin $PATH'"
