" Installation notes:
" 1. Download this .vimrc with 'curl -sSL rbf.li/vimrc -o .vimrc'
" 2. Install Pathogen, see https://github.com/tpope/vim-pathogen#installation
" 3. Install the solarized theme, see https://github.com/altercation/vim-colors-solarized#option-2-pathogen-installation-recommended
" 4. Enjoy

" URL: http://vim.wikia.com/wiki/Example_vimrc
" Authors: http://vim.wikia.com/wiki/Vim_on_Freenode
" Description: A minimal, but feature rich, example .vimrc. If you are a
"              newbie, basing your first .vimrc on this file is a good choice.
"              If you're a more advanced user, building your own .vimrc based
"              on this file is still a good idea.

" DOC: https://github.com/tpope/vim-pathogen#installation
execute pathogen#infect()

"------------------------------------------------------------
" Features {{{1
"
" These options and commands enable some very useful features in Vim, that
" no user should have to live without.

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

" Enable syntax highlighting
syntax on


"------------------------------------------------------------
" Must have options {{{1
"
" These are highly recommended options.

" One of the most important options to activate. Allows you to switch from an
" unsaved buffer without saving it first. Also allows you to keep an undo
" history for multiple files. Vim will complain if you try to quit without
" saving, and swap files will keep you safe if your computer crashes.
" set hidden

" Note that not everyone likes working this way (with the hidden option).
" Alternatives include using tabs or split windows instead of re-using the same
" window for multiple buffers, and/or:
" set confirm
" set autowriteall

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch

" Modelines have historically been a source of security vulnerabilities. As
" such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
" set nomodeline


"------------------------------------------------------------
" Usability options {{{1
"
" These are options that users frequently set in their .vimrc. Some of them
" change Vim's behaviour in ways which deviate from the true Vi way, but
" which are considered to add usability. Which, if any, of these options to
" use is very much a personal preference, but they are harmless.

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
" set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
" set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
" set t_vb=

" Enable use of the mouse for all modes
"set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
set number

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>


"------------------------------------------------------------
" Indentation options {{{1
"
" Indentation settings according to personal preference.

" Indentation settings for using 2 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=2
set softtabstop=2
set expandtab

" Indentation settings for using hard tabs for indent. Display tabs as
" two characters wide.
"set shiftwidth=2
"set tabstop=2


"------------------------------------------------------------
" Mappings {{{1
"
" Useful mappings

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>
"------------------------------------------------------------

"------------------------------------------------------------
" Custom {{{1
:let mapleader = ","

" SOURCE: http://vim.wikia.com/wiki/Using_tab_pages
set switchbuf=usetab,newtab

" From http://vim.wikia.com/wiki/Highlight_current_line
" :hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
:hi CursorLine   cterm=NONE ctermbg=234
" :hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
:hi CursorColumn cterm=NONE ctermbg=234
:nnoremap <Leader>r :set cursorline! cursorcolumn!<CR>
set cursorline cursorcolumn

" Settings for VimClojure
" From http://writequit.org/blog/?p=386
let vimclojure#HighlightBuiltins = 1 " Highlight Clojure's builtins
let vimclojure#ParenRainbow = 1      " Rainbow parentheses'!

" Install Solarized Theme
" OLD: mkdir -p ~/.vim/colors && cd ~/.vim/colors && curl -L rbf.li/solarizedvim -o solarized.vim 
" DOC: https://github.com/altercation/vim-colors-solarized#option-2-pathogen-installation-recommended

" Set up Solarized color scheme based on the current macOS interface style, i.e. dark or light.
" SOURCE: 09oct2021 https://stackoverflow.com/a/11266705
" SOURCE: 09oct2021 https://learnvimscriptthehardway.stevelosh.com/chapters/22.html
:if (match(system("defaults read -g AppleInterfaceStyle | tr \"[:upper:]\" \"[:lower:]\""), "dark") != -1)
:    set background=dark
:else
:    set background=light
:endif

let g:solarized_termcolors=256
colorscheme solarized
" SOURCE: https://github.com/altercation/vim-colors-solarized#toggle-background-function
call togglebg#map("<F5>")
" call togglebg#map("<Leader>t")
" call togglebg#map("")

" Set up SLIME.vim
let g:slime_target = "tmux"

" Spelling
highlight clear SpellBad
highlight SpellBad ctermfg=red cterm=underline
highlight clear SpellCap
highlight SpellCap ctermbg=darkred ctermfg=darkgreen cterm=underline
highlight clear SpellRare
highlight SpellRare ctermbg=darkred ctermfg=darkblue cterm=underline
highlight clear SpellLocal
highlight SpellLocal ctermbg=darkred ctermfg=darkyellow cterm=underline
set spell

" where it should get the dictionary files
let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'

" search for long lines
command LongLines /\%>80v.\+

" highlight 80th column
set colorcolumn=80

" SOURCE: https://github.com/airblade/vim-gitgutter#faq
autocmd BufWritePost * GitGutter

" SOURCE: https://stackoverflow.com/a/7692315
map <C-e> :NERDTreeFind<CR>
map <C-n> :NERDTreeToggle<CR>

" SOURCE: https://github.com/scrooloose/nerdcommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" SOURCE: https://vim.fandom.com/wiki/Copy_filename_to_clipboard
" Mnemonic: Copy Filename (path relative to where vim was started)
nnor ,cf :let @*=expand("%")<CR>
" Mnemonic: Copy Path
nnor ,cp :let @*=expand("%:p")<CR>
" Mnemonic: Yank Filename (path relative to where vim was started)
nnor ,yf :let @"=expand("%")<CR>
" Mnemonic: Yank Path
nnor ,yp :let @"=expand("%:p")<CR>

" SOURCE: https://github.com/junegunn/fzf#as-vim-plugin
set rtp+=/usr/local/opt/fzf
" Mnemonic: Find Files
nnor ,ff :Files<CR>
" Mnemonic: Find All
" Requires https://github.com/ggreer/the_silver_searcher
nnor ,fa :Ag<CR>
