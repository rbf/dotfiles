# The MIT License (MIT)
#
# Copyright (c) 2012-2021 https://github.com/rbf
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

export IS_RUNNING_INSIDE_TMUX="false"
if [[ -n "${TMUX}" ]]; then
  IS_RUNNING_INSIDE_TMUX="true"
fi

RELATIVE_SHLVL=$(($SHLVL - 1))
if $IS_RUNNING_INSIDE_TMUX; then
  RELATIVE_SHLVL=$(($RELATIVE_SHLVL - 1))
fi

IS_RUNNING_AS_A_SUB_SHELL=false
if (($RELATIVE_SHLVL > 0)); then
   IS_RUNNING_AS_A_SUB_SHELL="true"
fi

IS_SUB_PANE_IN_TMUX_WINDOW="false"
if $IS_RUNNING_INSIDE_TMUX && (($($(brew --prefix)/bin/tmux list-panes | wc -l | xargs echo) > 1)) ; then
  IS_SUB_PANE_IN_TMUX_WINDOW="true"
fi

IS_ALLOWED_TO_PRINT_LOGIN_GREETING=${IS_ALLOWED_TO_PRINT_LOGIN_GREETING:-true}
if $IS_RUNNING_AS_A_SUB_SHELL || $IS_SUB_PANE_IN_TMUX_WINDOW; then
  IS_ALLOWED_TO_PRINT_LOGIN_GREETING="false"
fi

# # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# # Initialization code that may require console input (password prompts, [y/n]
# # confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi
# # Since we print some login greeting info (see commands called at the bottom
# # of the file) we generally don't want to enable instant prompt to avoid
# # seeing the prompt blink before the login greeting appears. Since in tmux
# # sub-panels. e.i. panels other than the one that is automatically open with a
# # new window, the login greeting is not shown (so save space and avoid
# # redundancy), we could enable it there. But there are some parts of the prompt
# # that can not be printed instantly, so it blinks anyway. So we keep it always
# # disabled for now.

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# If powerlevel10k is installed as a oh-my-zsh plugin, enable it by defining this var:
# ZSH_THEME="powerlevel10k/powerlevel10k"

# If powerlevel10k is installed with brew, enable it by sourcing this script:
source "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme"

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

# Added as 'sub_shell_indicator' at the beginning of the POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
# array in ~/.p10k.zsh.
# SOURCE: 13oct2021 https://github.com/romkatv/powerlevel10k/issues/169#issuecomment-521381144
function prompt_sub_shell_indicator(){
  $IS_RUNNING_AS_A_SUB_SHELL || return
  p10k segment -t "%F{015}$(repeat ${RELATIVE_SHLVL} printf "↪")"
}

# Set personal aliases and functions, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# Use lsd as an alternative to ls.
# SOURCE: 28jun2021 https://github.com/Peltoche/lsd
# Check also the config file at ~/.config/lsd/config.yaml
alias ls='lsd'
# -A, --almost-all  Do not list implied . and ..
# -l, --long        Display extended file metadata as a table
alias la='ls -lA'
alias las='la -Sr'
alias lat='la -tr --date relative'

function cdf() {
  if ! [ -d "${*}" ]; then
    echo "Creating directory '${*}'..."
    mkdir -p "${*}"
  fi
  cd "${*}"
}

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

# This is the same image as https://hub.docker.com/r/texlive/texlive
# SOURCE: https://gitlab.com/islandoftex/images/texlive
function pdflatex() {
    TEXLIVE_IMAGE_NAME="registry.gitlab.com/islandoftex/images/texlive:latest-full"
    docker run --pull=never --rm -v "$(pwd):/workdir" -u $(id -u):$(id -g) --platform linux/amd64 "${TEXLIVE_IMAGE_NAME}" pdflatex ${@}
    if [ "$?" -eq 125 ]; then
        # The image cannot be found locally.
        echo
        echo "Automatically pulling ${TEXLIVE_IMAGE_NAME} image..."
        echo
        docker run --rm -v "$(pwd):/workdir" -u $(id -u):$(id -g) --platform linux/amd64 "${TEXLIVE_IMAGE_NAME}" pdflatex ${@}
    fi
}

# SOURCE: https://hub.docker.com/r/pandoc/extra
function pandock() {
    PANDOC_IMAGE_NAME="pandoc/extra"
    docker run --pull=never --rm -v "$(pwd):/data" -u $(id -u):$(id -g) --platform linux/amd64 "${PANDOC_IMAGE_NAME}"
    if [ "$?" -eq 125 ]; then
        # The image cannot be found locally.
        echo
        echo "Automatically pulling ${PANDOC_IMAGE_NAME} image..."
        echo
        docker run  --rm -v "$(pwd):/data" -u $(id -u):$(id -g) --platform linux/amd64 "${PANDOC_IMAGE_NAME}"
    fi
}

# SOURCE: https://jupyter-docker-stacks.readthedocs.io/en/latest/
# SOURCE: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-datascience-notebook
# SOURCE: https://stackoverflow.com/a/60236944
function jupyter-datascience-notebook() {
    JUPYTER_IMAGE_NAME="quay.io/jupyter/datascience-notebook"
    docker run -it --rm --name jupyter -v ./:/home/jovyan/work --platform linux/amd64 -p 8888:8888 ${JUPYTER_IMAGE_NAME} start-notebook.py --IdentityProvider.token=''
    if [ "$?" -eq 125 ]; then
        # The image cannot be found locally.
        echo
        echo "Automatically pulling ${JUPYTER_IMAGE_NAME} image..."
        echo
        docker run -it --rm --name jupyter -v ./:/home/jovyan/work --platform linux/amd64 -p 8888:8888 ${JUPYTER_IMAGE_NAME} start-notebook.py --IdentityProvider.token=''
    fi
}

# Instead of using ohmyzsh plugin 'sublime' I define the aliases I use.
# Inspired by my previous bashrc file.
# SOURCE: 08oct2021 https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sublime
# SOURCE: 08oct2021 https://gist.github.com/rbf/1844923#file-bashrc-L79-L116
alias subl3='/Applications/Sublime\ Text\ 3.app/Contents/SharedSupport/bin/subl'
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

function __create_new_sublime_project_file() {
  local filename="$(basename $(pwd)).sublime-project"
  [ -f "${filename}" ] && { backup "${filename}" 1>/dev/null || return 1; }
  cat << EOF > "${filename}"
{
  "folders":
  [
    {
      "path": ".",
      "folder_exclude_patterns": ["tmp", "node_modules", "log", "_build", "deps"],
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
# SOURCE: 28jun2021 https://github.com/romkatv/powerlevel10k/blob/4f3d2ff/config/p10k-classic.zsh#L6
function lscolors() (
  for i in {0..255}; do
    print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}
  done
)

# SOURCE: 02nov2021 https://www.linuxcommand.org/lc3_adv_tput.php
function color-matrix-tput() (
  text="${1:- Az }"
  cell_witdh=${#text}
  max_number_of_color_rows=$(($(tput lines) - 5))
  max_number_of_color_cols=$(((($(tput cols) - 15) / cell_witdh) - 2))
  for fg_color in {-1..${max_number_of_color_rows}}; do
      if ((fg_color == -1)); then
        printf 'tput setab      '
      elif ((fg_color > 255)); then
        continue
      else
        printf "tput setaf %3d |$(tput setaf $fg_color)" $fg_color
      fi
      for bg_color in {0..${max_number_of_color_cols}}; do
        if ((bg_color > 255)); then
          continue
        elif ((fg_color == -1)); then
          printf "%${cell_witdh}d" ${bg_color}
        elif ((fg_color == bg_color)); then
          printf "$(tput setab 0)%${cell_witdh}s" ' '
        else
          printf "$(tput setab $bg_color)${text}"
        fi
      done
      echo $(tput sgr0)
  done
)

# MUCH faster (i.e. instantaneous) that the version with 'tput', but 'print'
# (i.e. not 'printf') is avaible on zsh, and not in bash. Inspired by the
# 'lscolors' function above.
# SOURCE: 02nov2021 https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html
# SOURCE: 02nov2021 https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Prompt-Expansion
# SOURCE: 02nov2021 https://ndench.github.io/bash/parsing-bash-flags
function color-matrix-print() (
  set -o pipefail
  function f() (
    number_of_available_colors=255
    while (( # > 0 )); do
      case "${1}" in
        --number-of-colors|-n )
          print -P "%F{1}Missing number, e.g. --number-of-colors=10 or -n=10%f"
          exit 1
          ;;
        --number-of-colors=[1-9]|-n=[1-9] )
          ;&
        --number-of-colors=[1-9][0-9]|-n=[1-9][0-9] )
          ;&
        --number-of-colors=[1-9][0-9][0-9]|-n=[1-9][0-9][0-9] )
          n=$((${1##*=} - 1))
          shift
          max_number_of_color_rows=${n}
          max_number_of_color_cols=${n}
          ;;
        --all-colors|-a )
          shift
          max_number_of_color_rows=$number_of_available_colors
          max_number_of_color_cols=$number_of_available_colors
          ;;
        -- )
          shift
          break
          ;;
        -* )
          print -P "%F{1}Unsupported option ${1}%f"
          exit 1
          ;;
        * )
          break
          ;;
      esac
    done
    text="${*:- %F{fgc\}%K{bgc\} Az %k%f }"
    cell_witdh=${#text}
    text="${text//\%/%%}"
    raw_text_length=${#text}
    rows_for_padding=4
    max_number_of_color_rows=${max_number_of_color_rows:-$(($(tput lines) - rows_for_padding))}
    first_col_width=23
    max_number_of_color_cols=${max_number_of_color_cols:-$(((($(tput cols) - first_col_width) / cell_witdh) - 1))}
    long_header_length=11
    for fg_color in {-1..${max_number_of_color_rows}}; do
        if ((fg_color == -1)); then
          if ((cell_witdh > long_header_length)); then
            print -n 'print -Pn              '
          else
            print -n 'print -Pn "%K{n}%k"; n='
          fi
        elif ((fg_color > number_of_available_colors)); then
          continue
        else
          print -Pnf "          %-11s %s" "\"%%F{${fg_color}}%%f\"" "|%F{$fg_color}"
        fi
        for bg_color in {0..${max_number_of_color_cols}}; do
          if ((bg_color > number_of_available_colors)); then
            continue
          elif ((fg_color == -1)); then
            if ((cell_witdh > long_header_length)); then
              header="\"%K{${bg_color}}%k\""
            else
              header="${bg_color}"
            fi
            print -n "${(l:${cell_witdh}:)header}"
            continue
          elif ((fg_color == bg_color)); then
            print -Pn "%K{0}${(l:${cell_witdh}:)}%k"
            continue
          fi
          cell_text="${text//fgc/${fg_color}}"
          cell_text="${cell_text//bgc/${bg_color}}"
          print -Pn "%K{$bg_color}${(l:${raw_text_length}:)cell_text}%k"
        done
        print -P "%f"
    done
  )
  f "${@}" | less -SFRXK
)

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
    --holiday-list=short \
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

function is_this_the_root_of_a_linked_worktree_of_a_git_repo() {
  is_this_in_a_git_repo && [[ -f .git ]]
}

function show_directory_info() {
  local items_in_dir=(*(DN))
  local non_hidden_items_in_dir=(*(N))
  local comon_lsd_args=(--long --date=relative --timesort)
  case ${#items_in_dir}-${#non_hidden_items_in_dir} in
    0-0)
      echo "$(pretty_print_current_dir) is empty."
      ;;
    1-*)
      echo "One item in $(pretty_print_current_dir):"
      ls $comon_lsd_args --almost-all
      ;;
    2-*|3-*|4-*|5-*|6-*|7-*|8-*|9-*|10-*|11-*|12-*|13-*|14-*|15-*)
      echo "${#items_in_dir} items in $(pretty_print_current_dir):"
      ls $comon_lsd_args --almost-all
      ;;
    *-2|*-3|*-4|*-5|*-6|*-7|*-8|*-9|*-10|*-11|*-12|*-13|*-14|*-15)
      echo "${#items_in_dir} items in $(pretty_print_current_dir). ${#non_hidden_items_in_dir} non-hidden items:"
      ls $comon_lsd_args
      ;;
    *)
      echo "${#items_in_dir} items in $(pretty_print_current_dir). 5 most recently modified:"
      ls $comon_lsd_args --almost-all --color=always | tail -5
      ;;
  esac
}

# Accepts input as argument or from sdtin.
#
# Examples:
#
# $ slugify '"Låst Nàmê, Fïrst Ñämé" <email.addreß@example.org>'
# last-name-first-name-email-address-example-org
#
# $ cat << EOF | slugify
# [{>>Lòrêm<<}] Ípsüm çër ø úr \\prent- \og <turfræðibran> staðall í síðan um 1500,
# þegar óþekr!? tók röð A:F Það "glaði/því/sýnibó".
# Ligatures sœur, Straße & encyclopædia are properly transliterated. | tr -cd '[:alnum:]' >>>!
# Other alphabets абвгд-ежзий-кл-мн-опрст-уфхцч-шщъыьэюя,「おはよう。春樹兄さん。寝癖ついてるよ。」 and emoji 🙅‍♀️ are omitted. <<
# EOF
# lorem-ipsum-cer-o-ur-prent-og-turfraedibran-stadall-i-sidan-um-1500-thegar-othekr-tok-rod-a-f-\
# thad-gladi-thvi-synibo-ligatures-soeur-strasse-encyclopaedia-are-properly-transliterated-tr-cd-\
# alnum-other-alphabets-and-emoji-are-omitted
#
# SOURCE: 14oct2021 https://unix.stackexchange.com/a/631653
# SOURCE: 14oct2021 https://stackoverflow.com/a/44811468
# SOURCE: 14oct2021 https://stackoverflow.com/a/37511665
function slugify() {
  echo $(if [ -p /dev/stdin ]; then cat -; else echo "${*}"; fi) \
     | tr -sc '[:alnum:]' '-' \
     | iconv -c -f utf-8 -t ASCII//TRANSLIT \
     | tr -dc '[:alnum:]-' \
     | tr '[:upper:]' '[:lower:]' \
     | sed  -e 's/^--*//' -e 's/---*/-/g' -e 's/--*$//'
}

function pretty_print_current_dir() {
  # Like pwd but without expanding home directory.
  # SOURCE: 01jul2021 https://unix.stackexchange.com/a/207214
  local current_path="$(dirs -p | head -1)"
  if [[ "${current_path}" == '~' ]]; then
    # Print the full path for the home directory instead of just ~.
    echo "home directory $(pwd) (~)"
  else
    echo "${current_path}"
  fi
}

function show_last_modified_files_in_tree() {
  # SOURCE: 01jul2021 https://unix.stackexchange.com/a/207214
  # SOURCE: 10oct2021 https://unix.stackexchange.com/a/200267
  echo "Most recently modified files in this repo:"
  find *(DN) -not -name .DS_Store -not -name '*.sublime-workspace' -not -path '.git/*' -not -path '.linked-worktrees/*' -maxdepth 4 -type f -print0 \
    | xargs -0 lsd --almost-all --long --timesort --date relative --color always \
    | head -3
}

function show_git_repo_info() {
  show_last_modified_files_in_tree
  echo
  git spaced-after throttled-fetch --all --prune --progress
  git br
  echo
  git h
  echo
  git spaced-after todo
  git imp-is-main-branch-checked-out || git spaced-after st-upstream-remote-main
  git st
  return 0
}

function show_git_repo_info_in_linked_worktree() {
  echo
  git h
  echo
  printf "This is a linked worktree of the main"
  printf " worktree at $(cat .git | sed -e 's/^gitdir: \(.*\)\/.git\/.*/\1/').\n"
  echo
  return 0
}

function context() {
  if is_this_the_root_of_a_git_repo; then
    show_git_repo_info
  elif is_this_the_root_of_a_linked_worktree_of_a_git_repo; then
    show_git_repo_info_in_linked_worktree
  else
    show_directory_info
  fi
}
alias c='context'

# zsh-hook function executed whenever the current working directory is changed.
# SOURCE: 01jul2021 https://stackoverflow.com/a/3964198
# DOC: https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions
function chpwd() {
  context
}

# Duplicate a file adding the extention .bak_[timestamp]
# SOURCE: 28jun2021 https://gist.github.com/rbf/1844923#file-bashrc-L79-L88
function backup() {
  if [ -z "${1}" ]
  then
    echo "Missing file to backup. Nothing to do." 1>&2
    return 1
  fi
  BACKUP_FILENAME="${1}.bak_$(date +"%Y%m%d%H%M%S")";
  cp "${1}" "${BACKUP_FILENAME}" && echo "Backup created: ${BACKUP_FILENAME}";
}

# SOURCE: 04sep2021 https://docs.gl-inet.com/en/3/tutorials/vpn_policies/#clear-dns-cache
alias cleardnscache='sudo killall -HUP mDNSResponder'

alias reload='source ~/.zshrc'

# Usage: jwtd XXXXXX.YYYYYYY.ZZZZZZZ
# SOURCE: 17jan2022 https://prefetch.net/blog/2020/07/14/decoding-json-web-tokens-jwts-from-the-linux-command-line/
jwtd() {
  if [[ -x $(command -v jq) ]]; then
    jq -R 'split(".") | .[0],.[1] | @base64d | fromjson' <<< "${1}"
    echo "Signature: $(echo "${1}" | awk -F'.' '{print $3}')"
  fi
}

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
export PATH="/usr/local/sbin:$HOME/.docker/bin:$PATH"

# Ensure that LANG is properly set up and avoid the error 'Unknown locale, assuming C' with man.
# SOURCE: https://apple.stackexchange.com/a/452339
export LANG=en_US.UTF-8

# Allow gpg to find the current terminal to sign git commits.
# SOURCE: 20oct2021 https://stackoverflow.com/a/42265848
# DOC: https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key#telling-git-about-your-gpg-key
export GPG_TTY=$TTY

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

# See 'zsh/brew_update_job' file for details.
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
      echo "There is one brew package outdated as per $(date -r "${outdated_packages_file}"):"
      echo
      echo "  ${outdated_packages}"
      echo
      echo "Run 'brew upgrade' to upgrade it."
      echo
      ;;
    *)
      echo "There are ${#outdated_packages} brew packages outdated as per $(date -r "${outdated_packages_file}"):"
      echo
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

if $IS_ALLOWED_TO_PRINT_LOGIN_GREETING; then
  mcal
  echo
  list_outdated_brew_packages
fi

if ${IS_CONTEXT_TO_BE_PRINTED:-false}; then
  context
  unset IS_CONTEXT_TO_BE_PRINTED
fi

if ${IS_SUBLP_TO_BE_CALLED:-false}; then
  echo
  sublp
  echo
  unset IS_SUBLP_TO_BE_CALLED
fi

unset -f list_outdated_brew_packages

$(pvm --setup-zsh-env)

pvm-dev () {
        if [ ${1} = "reset" ]
        then
                if [ -n "${__PVM_TARGET}" ]
                then
                        __pvm_reset_env
                else
                        echo "Nothing to reset"
                fi
                return
        fi
        ~/dev/repos/github/rbf/pvm/pvm "${@}"
        if [ -f ".pvm/env" ]
        then
                source ".pvm/env"
                rm ".pvm/env"
        fi
}

# LS_COLORS controls how ls (and lsd) colorize filnames, although not sure what the codes really mean.
# SOURCE: https://www.bigsoft.co.uk/blog/2008/04/11/configuring-ls_colors
# The default with oh_my_zsh (I think it comes from it) is:
# export LS_COLORS='di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
# Overwrite it with an empty one to use the normal defauls.
# export LS_COLORS=''


# vivid is a generator for the LS_COLORS environment variable that controls the colorized output of ls and lsd.
# SOURCE: https://github.com/sharkdp/vivid/tree/master

# To try all available themes with your current directory:
#  for theme in $(vivid themes); do
#      echo "Theme: $theme"
#      LS_COLORS=$(vivid -m 8-bit generate $theme)
#      tree
#      echo
#  done

export LS_COLORS="$(vivid -m 8-bit generate catppuccin-latte)"
