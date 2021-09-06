# dotfiles

Personal dotfiles repository

## Quick start

### bat

```sh
stow -t $(dirname $(dirname $(bat --config-file))) bat
```

### git

```sh
stow --dotfiles -t $HOME git
```

### tmux

```sh
stow --dotfiles -t $HOME tmux
```

### zsh

```sh
stow --dotfiles -t $HOME zsh
```
