# `git` configuration files

## `.gitconfig`

This `.gitconfig` file started as simple a [gist][originalgitconfiggist] in
February 2012:

```gitconfig
[color]
  ui = auto
[alias]
  co = checkout
  ci = commit
  st = status -sb
  br = branch
  difft = difftool
  ds = diff HEAD --stat
  dsc = diff --cached --stat
  hist = log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=relative
  h = log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=relative -n 5
  type = cat-file -t
  dump = cat-file -p
[diff]
  tool = opendiff
[difftool]
  prompt = false
[core]
  editor = /usr/bin/vim
```

For the next 6+ years I kept updating the [original gist][originalgitconfiggist]
until on May 2018 I moved it to this `dotfiles` repo.

### Install

A detailed description is kept in the header of the `.gitconfig` file itself,
for reference when installed. The short version is

```bash
bash <(curl -sSL rbf.li/gci)
```

### Customization

Please do not modify this `.gitconfig` file with your tweaks or preferences
because your changes will be lost when you update it with `git
update-gitconfig`. Instead create a file named `.gitconfig.local` in the same
directory as the `.gitconfig` and add your customizations (including your user
name and email) in that file.

[originalgitconfiggist]: https://gist.github.com/rbf/1845578

## `.gitignore`

This `.gitignore` file started also as a standalone
[gist][originalgitignoregist] in March 2012.

[originalgitignoregist]: https://gist.github.com/rbf/2224744
