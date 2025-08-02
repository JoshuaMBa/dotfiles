**Dotfiles**

My dotfiles setup. Run `git clone https://github.com/JoshuaMBa/dotfiles.git && cd dotfiles && source scripts/setup.sh` to setup up dotfiles. Run `git pull && source scripts/update.sh` to fetch and apply updates. Note that you may still need to make changes so that `tmux` can be found through your `$PATH`. Currently I've added support for `tmux` (installed with homebrew) on MacOS in `.commonrc`.

Local git, bash, or zsh configurations can be applied by adding a `.gitconfig.local`, `.bashrc.local`, or `.zshrc.local` file, respectively, to the `$HOME` directory.
