# dotfiles

```bash
git clone https://github.com/damienpontifex/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles
stow .
```

## Touch ID in tmux

Put this in /etc/pam.d/sudo_local
Require pam_reattach so it works inside tmux
```conf
auth       optional     /opt/homebrew/lib/pam/pam_reattach.so
auth       sufficient     pam_tid.so
```
