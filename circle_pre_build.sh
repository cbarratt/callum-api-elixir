#!/bin/bash
# Ensure exit codes other than 0 fail the build

set -e

# Check for asdf
if ! asdf | grep version; then
 git clone https://github.com/HashNuke/asdf.git ~/.asdf;
fi

# Add plugins for asdf
asdf plugin-add erlang https://github.com/HashNuke/asdf-erlang.git
asdf plugin-add elixir https://github.com/HashNuke/asdf-elixir.git

# Install erlang/elixir
asdf install erlang 18.3
asdf install elixir 1.2.5

# Get dependencies
yes | mix local.rebar
yes | mix local.hex
yes | mix deps.get

# Exit successfully
exit 0
