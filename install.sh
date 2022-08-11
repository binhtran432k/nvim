#!/bin/bash

echo "Cloning Required Plugins"

pack_dir=~/.local/share/nvim/site/pack/packer/start
init_file=./init.lua

git clone -q --depth 1 https://github.com/wbthomason/packer.nvim \
  $pack_dir/packer.nvim && \
git clone -q --depth 1 https://github.com/rktjmp/hotpot.nvim \
  $pack_dir/hotpot.nvim && \
cat > $init_file <<EOF
require("hotpot").setup()
require("startup")
EOF
