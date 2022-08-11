#!/bin/bash

echo "Removing Plugins"

pack_dir=~/.local/share/nvim/site/pack/packer

rm -f ./init.lua
rm -rf ./lua
rm -rf $pack_dir
