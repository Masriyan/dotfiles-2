# dotfiles

Personal dotfiles repository

## Quick start

### bat

```sh
stow -t $(dirname $(dirname $(bat --config-file))) bat
```

### tmux

```sh
stow --dotfiles -t $HOME tmux
```

### zsh

```sh
stow --dotfiles -t $HOME zsh
```
