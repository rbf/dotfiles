# Execute this line on your *nix system to download and install the .gitconfig
# and the .gitignore files for the first time.
# Afterwards, we can run 'git update-gitconfig' to do it automatically.
# SOURCE: https://github.com/rbf/dotfiles/blob/master/git
[ -f ~/.gitconfig ] && cat ~/.gitconfig >> ~/.gitconfig.local; curl -#SL https://raw.githubusercontent.com/rbf/dotfiles/master/git/.gitconfig -o ~/.gitconfig
[ -f ~/.gitignore ] && cp -v ~/.gitignore ~/.gitignore.backup_$(date +"%Y%m%d%H%M%S"); curl -#SL https://raw.githubusercontent.com/rbf/dotfiles/master/git/.gitignore -o ~/.gitignore
