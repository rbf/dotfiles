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

### Sign commits with GPG

Follow the instruction from [GitHub][github-gpg] or [Gitlab][gitlab-gpg] on how
to set it up. Below I list how to fix some errors I encountered in the way.

#### Trust imported key

If you are importing an existing GPG key to your system (for example, from
[ProtonMail](https://protonmail.com/support/knowledge-base/download-public-private-key/)), you might
need to manually trust it ([source](https://yanhan.github.io/posts/2014-03-04-gpg-how-to-trust-imported-key/) and [source](https://github.com/pstadler/keybase-gpg-github#import-key-to-gpg-on-another-host)).

```bash
gpg --edit-key 'your email or key id'
gpg> trust

Please decide how far you trust this user to correctly verify other users' keys
(by looking at passports, checking fingerprints from different sources, etc.)

 1 = I don't know or won't say
 2 = I do NOT trust
 3 = I trust marginally
 4 = I trust fully
 5 = I trust ultimately
 m = back to the main menu

Your decision? 5
Do you really want to set this key to ultimate trust? (y/N) y

gpg> quit
```

#### Configure `git` to use your key

The `user.signingkey` is the id of the private key to be used for signing. You
can retrieve it with `gpg --list-secret-keys --keyid-format LONG`. The necessary
id is between the slash (`/`) and the first white space (` `) in the line that
starts with `sec`. I.e.:

```bash
gpg --list-secret-keys --keyid-format LONG 'your email or key id' \
 | grep ^sec \
 | sed 's|.*\/\([[:alnum:]]*\) .*|\1|' \
 | xargs git config --file "~/.gitconfig.local" user.signingkey
```

More details about this step on the [GitHub
documentation](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key#telling-git-about-your-gpg-key).

#### Sign commits by default

Set the following configuration to sign commits by default without the `-S`
flag:

```bash
git config --file "~/.gitconfig.local" commit.gpgsign true
```

#### Other issues

You might have to specify where is you gpg binary if git does not find it, or if
using a Git UI.

```bash
git config --file "~/.gitconfig.local" gpg.program $(which gpg)
```

In order to let `gpg` find your shell session and sign commits, you might need
to set the `GPG_TTY` ENV variable on your shell, e.g. `export GPG_TTY=$(tty)`.
You might want to add this to your `.bashrc`, `.zshrc` or similar login script.
Note that if you are using ZShell and Powerlevel10k with Instant Prompt enabled
you might need instead `export GPG_TTY=$TTY`
([source](https://stackoverflow.com/a/42265848)).


For further troubleshooting, you can set the following debug ENV variable
`GIT_TRACE=1`, e.g. ([source](https://stackoverflow.com/a/47561300)):

```bash
GIT_TRACE=1 git commit -S -m "Testing why git cannot sign the commit"
```

#### On macOS avoid asking for the password of the GPG key every time

Follow the steps in [this
post](https://github.com/pstadler/keybase-gpg-github#optional-in-case-youre-prompted-to-enter-the-password-every-time),
mainly:

1. Install [`pinentry-mac`](https://formulae.brew.sh/formula/pinentry-mac)
    ```bash
    brew install pinentry-mac
    ```
1. Tell `gpg-agent` to use the new `pinentry-mac` for password entry
    ```bash
    echo "pinentry-program /usr/local/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
    ```
1. Restart `gpg-agent`
    ```bash
    gpgconf --kill gpg-agent
    ```

[gitlab-gpg]: https://docs.gitlab.com/ee/user/project/repository/gpg_signed_commits/
[github-gpg]: https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key


## `.gitignore`

This `.gitignore` file started also as a standalone
[gist][originalgitignoregist] in March 2012.

[originalgitignoregist]: https://gist.github.com/rbf/2224744
