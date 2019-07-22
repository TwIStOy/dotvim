#!/usr/bin/env fish

nvim --cmd "profile start ~/vimprofile.result" --cmd "profile! file *dotvim/*" $argv

