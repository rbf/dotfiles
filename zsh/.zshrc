# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi
# 
# However, this is not enabled for now to avoid seeing the prompt before the
# login greeting (see commands called at the bottom of the file).

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"

# ohmyzsh Settings
# DOC: https://github.com/ohmyzsh/ohmyzsh/wiki/Settings#completion_waiting_dots

# Underscore and hyphen (i.e.  _ and -) are interchangeable in auto completion.
HYPHEN_INSENSITIVE="true"

# Disable marking untracked files under VCS as dirty. This makes repository
# status check for large repositories much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Format of the command execution time stamp shown in the history command output.
# Accepted formats are "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd". Alternatively
# you can set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# OhMyZsh Plugins to load.
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  docker                     # SOURCE: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker
  web-search                 # SOURCE: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/web-search
  z                          # SOURCE: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/z

  zsh-autosuggestions        # SOURCE: https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh
  fast-syntax-highlighting   # SOURCE: https://github.com/zdharma/fast-syntax-highlighting#oh-my-zsh
  )

# SOURCE 02jul2021 https://callstack.com/blog/supercharge-your-terminal-with-zsh/
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match
zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

source $ZSH/oh-my-zsh.sh

# SOURCE: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# Display comments in the shell prompt in dark grey.
# DOC: https://github.com/zdharma/fast-syntax-highlighting/blob/master/CHANGELOG.md
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}comment]='fg=8'

# Set personal aliases and functions, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# Use lsd as an alternative to ls.
# SOURCE: 28jun2021 https://github.com/Peltoche/lsd
# Check also the config file at ~/.config/lsd/config.yaml
alias ls='lsd  --color=$( [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == Dark ]] && echo auto || echo never)'
# -A, --almost-all  Do not list implied . and ..
# -l, --long        Display extended file metadata as a table
alias la='ls -lA'
alias las='la -Sr'
alias lat='la -tr --date relative'

# Print the arguments and wait for any key to be pressed to continue.
# SOURCE: 08oct2021 https://stackoverflow.com/a/47232956
function pause() read -s -k "?$*"$'\n'
function press_any_key_to_continue() pause "${*:-"Press any key to continue, or CTRL-C to abort."}"

function tree() {
  local depth="${1:-5}"
  if ! ((depth >= 1 && depth <= 10)); then
    echo "tree: Accepts only one optional integer argument to define the depth of the tree, and it must be between 1 and 10 (default: 5)"
    return 1
  fi
  ls --almost-all --depth ${depth} --tree --group-dirs=first --ignore-glob .git
}

# Alternative to lsd.
# SOURCE: 28jun2021 https://github.com/ogham/exa
alias laexa='exa -laa --group --header --git --icons --colour-scale --binary'

# Instead of using ohmyzsh plugin 'sublime' I define the aliases I use.
# Inspired by my previous bashrc file.
# SOURCE: 08oct2021 https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sublime
# SOURCE: 08oct2021 https://gist.github.com/rbf/1844923#file-bashrc-L79-L116
alias subl3='/Applications/Sublime\ Text\ 3.app/Contents/SharedSupport/bin/subl'
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

function __create_new_sublime_project_file() {
  local filename="$(basename $(pwd)).sublime-project"
  [ -f "${filename}" ] && backup "${filename}"
  cat << EOF > "${filename}"
{
  "folders":
  [
    {
      "path": ".",
      "folder_exclude_patterns": ["tmp", "bin", "log", "_build", "deps"],
    }
  ]
}
EOF
  echo "${filename}"
}

function ensure_file_present() {
  [[ -f "${@}" ]] && return
  echo "File not found: ${@}" 1>&2
  return 1
}

function sublp() {
  # Glob pattern matching: non-executable plain files.
  # SOURCE: 08oct2021 https://obda.net/blog/zsh-glob-qualifiers/
  #
  # The qualifier N means that Zsh will return an empty string instead of
  # failing with the "zsh: no matches found:" error if the globbing pattern
  # does not have any matches.  With the wording of the Zsh documentation:
  # "[The qualifier N] sets the NULL_GLOB option for the current pattern".
  # DOC: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers
  # SOURCE: 08oct2021 https://unix.stackexchange.com/a/313187
  # SOURCE: 08oct2021 https://www.bartbusschots.ie/s/2019/06/12/bash-to-zsh-file-globbing-and-no-matches-found-errors/
  local filename=(*.sublime-project(.N^*))

  case ${#filename} in
    0)
      press_any_key_to_continue 'No .sublime-project file found. Press any key to create a default one and open it.'
      filename="$(__create_new_sublime_project_file)"
      ensure_file_present "${filename}" || return 1
      # Fall through to the next case.
      # DOC: https://zsh.sourceforge.io/Doc/Release/Shell-Grammar.html
      ;&
    1)
      echo "Opening project '${filename}' with SublimeText 4..."
      subl --project "${filename}"
      ;;
    *)
      echo "There are ${#filename} '.sublime-project' files. Run one of the commands below to open the corresponding project on SublimeText 4:"
      printf 'subl --project %s\n' "${filename[@]}"
      return 1
      ;;
  esac
}

# SOURCE: 28jun2021 https://askubuntu.com/a/1309434
function lscolors() {
  for i in {0..255}; do
    print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}
  done
}

# SOURCE: 28jun2021 https://github.com/chubin/wttr.in
# VIA: https://towardsdatascience.com/the-ultimate-guide-to-your-terminal-makeover-e11f9b87ac99
function weather() {
  case ${1:-1} in
    1)
      curl --max-time 2.0 wttr.in/${2:-${__LOCAL_WEATHER_DEFAULT_LOCATION}}\?format="%T+%l:+%c++%C+%t+(%f)+%P+%h+%p/3h+%w+%S-%s+%m\\n"
      ;;
    2)
      curl --max-time 2.0 wttr.in/${2:-${__LOCAL_WEATHER_DEFAULT_LOCATION}}\?Q0F
      ;;
    3)
      curl --max-time 2.0 wttr.in/${2:-${__LOCAL_WEATHER_DEFAULT_LOCATION}}\?Q3F
      ;;
    4)
      curl --max-time 3.0 v2.wttr.in/${2:-${__LOCAL_WEATHER_DEFAULT_LOCATION}}\?QF
      ;;
  esac
}

# DOC: https://www.gnu.org/software/gcal/manual/gcal.html
function mcal() {
  gcal \
    --with-week-number \
    --starting-day=Monday \
    --cc-holidays="${__LOCAL_MCAL_CC_HOLIDAYS_LOCATION}" \
    --descending-holiday-list=short \
    --exclude-holiday-list-title \
    --suppress-holiday-list-separator \
    --highlighting='\033[7;1m:\033[0m:\033[91;1m:\033[0m' \
    --highlighting=yes \
    --date-format="${__LOCAL_MCAL_DATE_FORMAT}" \
    . | tail -n +2
}

function is_this_the_home_directory() {
  [[ $(pwd) == ~ ]]
}

# Returns true if the current directory is in the tree of the argument directory,
# i.e. it matches the passed argument or the argument it's in the full path.
function is_this_in_the_tree_under_directory() {
  [[ -z "${@#/}" ]] && echo "Provide the name or path of the directory." 1>&2 && return 1
  [[ $(pwd) =~ /"${@#/}"(/.*|$)? ]]
}

function is_this_in_a_git_repo() {
  git rev-parse --git-dir 1>/dev/null 2>/dev/null
}

function is_this_the_root_of_a_git_repo() {
  is_this_in_a_git_repo && [[ -d .git ]]
}

function show_directory_info() {
  local items_in_dir=(*(DN))
  case ${#items_in_dir} in
    0)
      echo "$(current_dir_without_expanding_home_directory) is empty."
      ;;
    1)
      echo "One item in $(current_dir_without_expanding_home_directory):"
      la
      ;;
    2|3|4|5|6|7|8)
      echo "${#items_in_dir} items in $(current_dir_without_expanding_home_directory):"
      la
      ;;
    *)
      echo "${#items_in_dir} items in $(current_dir_without_expanding_home_directory). Most recently modified:"
      la --timesort --date relative --color always | head -3
      ;;
  esac
}

function current_dir_without_expanding_home_directory() {
  # SOURCE: 01jul2021 https://unix.stackexchange.com/a/207214
  dirs -p | head -1
}

function show_last_modified_files_in_tree() {
  # SOURCE: 01jul2021 https://unix.stackexchange.com/a/207214
  # SOURCE: 10oct2021 https://unix.stackexchange.com/a/200267
  CURRENT_DIR_WITHOUT_EXPANDING_HOME_DIRECTORY="$(dirs -p | head -1)"
  echo "Most recently modified files in this repo:"
  find *(D) -not -name .DS_Store -not -path ".git/*" -maxdepth 4 -type f -print0 \
    | xargs -0 lsd --almost-all --long --timesort --date relative --color always \
    | head -3
}

function show_git_repo_info() {
  show_last_modified_files_in_tree
  echo
  git h
  echo
  git st
  return 0
}

alias context='show_git_repo_info'

# zsh-hook function executed whenever the current working directory is changed.
# SOURCE: 01jul2021 https://stackoverflow.com/a/3964198
# DOC: https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions
function chpwd() {
  if is_this_the_home_directory; then
    # Nothing to do.
  elif is_this_the_root_of_a_git_repo; then
    show_git_repo_info
  else
    show_directory_info
  fi
}

# Duplicate a file adding the extention .bak_[timestamp]
# SOURCE: 28jun2021 https://gist.github.com/rbf/1844923#file-bashrc-L79-L88
function backup() {
  if [ -z "${1}" ]
  then
    echo "Missing file to backup. Nothing to do."
    return 1
  fi
  BACKUP_FILENAME="${1}.bak_$(date +"%Y%m%d%H%M%S")";
  cp "${1}" "${BACKUP_FILENAME}" && echo "Backup created: ${BACKUP_FILENAME}";
}

# SOURCE: 04sep2021 https://docs.gl-inet.com/en/3/tutorials/vpn_policies/#clear-dns-cache
alias cleardnscache='sudo killall -HUP mDNSResponder'

alias reload='source ~/.zshrc'

# Set Ctrl-U to do the same as in Bash
# SOURCE: 15may2021 https://stackoverflow.com/a/3483679
bindkey \^U backward-kill-line

# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/Users/rob/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

function is_macos_in_dark_mode() {
  [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]
}

# As suggested by "brew doctor":
#   Warning: Homebrew's "sbin" was not found in your PATH but you have installed
#   formulae that put executables in /usr/local/sbin.
#   Consider setting your PATH for example like so:
#   echo 'export PATH="/usr/local/sbin:$PATH"' >> ~/.zshrc
export PATH="/usr/local/sbin:$PATH"

# The BAT_THEME seems also to be picked up by git d when using delta (although
# not specified in delta's docs).
# DOC: https://github.com/sharkdp/bat#highlighting-theme
# DOC: https://github.com/dandavison/delta#custom-themes

# These 2 bat themes dynamically adapt to the light/dark macOS interface styles,
# but they look a bit rough.
# export BAT_THEME="ansi"
# export BAT_THEME="base16"

# These 2 bat themes do not dynamically adapt to the light/dark macOS interface
# styles (i.e. .zshrc must be reloaded in order to change the theme for bat and
# delta), but they look nicer.
# export BAT_THEME="Solarized (dark)"
# export BAT_THEME="Solarized (light)"

function dynamic_bat_theme_name() {
  if is_macos_in_dark_mode; then
    echo "Solarized (dark)"
  else
    echo "Solarized (light)"
  fi
}

alias git='BAT_THEME="$(dynamic_bat_theme_name)" git'
alias bat='BAT_THEME="$(dynamic_bat_theme_name)" bat'

# Put your personal modifications on ~/.zshrc.local, which won't be overwritten.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Schedule the regular 'brew update' with the following line (i.e. everyday at 9:23h and 21:23h):
#   crontab -l | { cat; echo "23 9,21 * * * $(pwd)/zsh/brew_update_job"; } | crontab -
# You might see a dialog to confirm that Terminal.app might update the settings of your computer.
# Also you might have to allow cron to access your disk. See links below.
# SOURCE: 11oct2021 https://serverfault.com/a/1012212
# SOURCE: 11oct2021 https://stackoverflow.com/a/879022
# SOURCE: 11oct2021 https://osxdaily.com/2020/04/27/fix-cron-permissions-macos-full-disk-access/
function list_outdated_brew_packages() {
  local outdated_packages_file=~/.cache/brew/outdated
  local outdated_packages=()

  [ -f "${outdated_packages_file}" ] || return

  cat "${outdated_packages_file}" | while read LINE; do
    outdated_packages+="${LINE}"
  done

  case ${#outdated_packages} in
    0)
      # nothing to do
      ;;
    1)
      echo "One brew package outdated:"
      echo "  ${outdated_packages}"
      echo
      echo "Run 'brew upgrade' to upgrade it."
      echo
      ;;
    *)
      echo "${#outdated_packages} brew packages outdated:"
      printf '  %s\n' "${outdated_packages[@]}"
      echo
      echo "Run 'brew upgrade' to upgrade them all."
      echo
      ;;
  esac

  # Remove the log file after showing it once to:
  #   1) prevent having to keep the file up-to-date after running 'brew upgrade'
  #   2) avoid showing it too often
  rm "${outdated_packages_file}"
}

mcal
echo

list_outdated_brew_packages
unset -f list_outdated_brew_packages
