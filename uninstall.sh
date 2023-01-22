#!/bin/bash

echo "Removing Plugins"

pack_dir=~/.local/share/nvim/lazy/lazy.nvim

rm -f ./init.lua
rm -rf $pack_dir
