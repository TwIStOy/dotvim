#!/usr/bin/env fish

nvim --cmd "profile start ~/vimprofile.result" --cmd "profile! file *" --cmd 'profile! func *' $argv

