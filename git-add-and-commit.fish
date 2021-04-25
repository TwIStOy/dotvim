#!/usr/bin/env fish

function update-dotvim-date
  set -l repo_home (git rev-parse --show-toplevel)
  set -l today (date +%Y.%m.%d)

  if [ (uname) = "Darwin" ]
    gsed -i "3c last_updated_time = '$today'" $repo_home/autoload/dotvim/version.vim
  else
    sed -i "3c last_updated_time = '$today'" $repo_home/autoload/dotvim/version.vim
  end
  echo (set_color green)"version date updated..."(set_color normal)
end

function git-add-and-commit --description "update time & add & commit"
  set -l repo_home (git rev-parse --show-toplevel)
  set -l curr_path (pwd)

  if test (count $argv) -lt 1
    echo (set_color red)"should add commit messages..."(set_color normal)
    return
  end

  cd $repo_home

  set -l uncommit_changes (git status --porcelain)
  if test -z "$uncommit_changes"
    cd $curr_path
    echo (set_color green)"Working tree is clean..."(set_color normal)
    return
  end

  set -l today (date +%Y.%m.%d)
  echo (set_color green)"         Today: "(set_color normal)(set_color cyan)$today(set_color normal)
  echo (set_color green)"       Changes: "(set_color normal)
  git status -s -b

  echo (set_color green)"Commit Message: "(set_color normal)
  echo $argv[1]

  read -P "Continue? [y/N] " continue_str
  if [ $continue_str != 'y' ]
    echo (set_color red)"Abort"(set_color normal)
    cd $curr_path
    return
  end

  update-dotvim-date
  git add --all
  git commit -m $argv[1]

  cd $curr_path
end

git-add-and-commit $argv
