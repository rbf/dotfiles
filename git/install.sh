# Execute this line on your *nix system to download and install the .gitconfig
# and the .gitignore files for the first time. You can do it with the following
# short command:
#
#   bash <(curl -sSL rbf.li/gci)
#
# Afterwards, we can run 'git update-gitconfig' to do it automatically.
# SOURCE: https://github.com/rbf/dotfiles/blob/master/git

GITCONFIG_GLOBAL=~/.gitconfig
GITCONFIG_LOCAL="${GITCONFIG_GLOBAL}.local"

echo

if [ -f "${GITCONFIG_GLOBAL}" ]; then
  echo "Saving the contents of your current ${GITCONFIG_GLOBAL} into ${GITCONFIG_LOCAL}"
  cat "${GITCONFIG_GLOBAL}" >> "${GITCONFIG_LOCAL}"
fi

if [ ! -f "${GITCONFIG_LOCAL}" ]; then
  echo "Creating default ${GITCONFIG_LOCAL}"
  cat <<EOF >> "${GITCONFIG_LOCAL}"
# Here you can freely modify the configuration defined in the .gitconfig file,
# including your user name and email address. This file will not be overridden
# when the gitconfig is updated with "git update-gitconfig"
#
# [user]
#   name = YOUR_USERNAME
#   email = YOUR_EMAIL_ADDRESS
EOF
fi

echo "Downloading .gitconfig"
curl -#SL https://raw.githubusercontent.com/rbf/dotfiles/master/git/.gitconfig -o "${GITCONFIG_GLOBAL}"

echo

GITIGNORE_GLOBAL=~/.gitignore
if [ -f ~/.gitignore ]; then
  echo "Making a backup of your current ${GITIGNORE_GLOBAL}"
  cp -v ~/.gitignore ~/.gitignore.backup_$(date +"%Y%m%d%H%M%S")
fi
echo "Downloading .gitignore"
curl -#SL https://raw.githubusercontent.com/rbf/dotfiles/master/git/.gitignore -o "${GITIGNORE_GLOBAL}"

echo
echo "Done!"
echo "Now you can add your customizations in the file ${GITCONFIG_LOCAL}"
echo
