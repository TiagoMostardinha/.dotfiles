# Dotfiles

This directory contains all my dotfiles for my system.
It includes, the configuration files for:
- Bash
- Tmux
- Nvim
- ...

## Requirements

Ensure that you have the following tools installed on your system.

### Git

```
sudo dnf install git
```

### Stow

```
sudo dnf install stow
```

## Installation

First of all, check out the dotfiles repo in your $HOME directory using git.

```
$ git clone git@github.com:TiagoMostardinha/.dotfiles.git
$ cd .dotfiles
```

Then use GNU stow to create symlinks for the files.

```
$ stow .
```
