# dotfiles

Following guide at https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

## New machine

![CI](https://github.com/damienpontifex/dotfiles/workflows/CI/badge.svg)

The script requires curl and git to get started:
```bash
apt update && apt install -y curl git zsh software-properties-common
```

Run with a gist install script by:
```bash
curl -sL https://raw.githubusercontent.com/damienpontifex/dotfiles/master/.bootstrap | zsh
```

Or by cloning the repo as
```bash
git clone --bare https://github.com/damienpontifex/dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout
source $HOME/.bash_profile
dotfiles config --local status.showUntrackedFiles no
```
