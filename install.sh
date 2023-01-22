#!/bin/bash

echo "Cloning Required Plugins"

# pack_dir=~/.local/share/nvim/site/pack/packer
init_file=./init.lua

# git clone -q --depth 1 https://github.com/wbthomason/packer.nvim \
#   $pack_dir/opt/packer.nvim && \
# git clone -q --depth 1 https://github.com/rktjmp/hotpot.nvim \
#   $pack_dir/start/hotpot.nvim && \
cat > $init_file <<EOF
require("startup")
EOF
