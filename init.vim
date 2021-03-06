" When creating a custom .vimrc we need to re-enable the defaults
"unlet! skip_defaults_vim
"source $VIMRUNTIME/defaults.vim

" Set utf-8 encoding early to prevent issues later on
set encoding=utf-8
set fileencoding=utf-8

" ----- SET DIRECTORY ----- "
if !has('nvim')
	" Where to check for vimplug later on
	let g:vimplug_dir = "~/.vim/autoload/plug.vim"
else
	let g:vimplug_dir = "~/.config/nvim/autoload/plug.vim"
endif

" ----- VANILLA CONFIG ----- "

" -- CUSTOM SHORTCUTS -- "

" Space is used as the 'modifier'/'leader' key
let mapleader = " "

" Create new file if it doesnt exist
nnoremap cgf :e <cfile><CR>
" Go to path if it exists
nnoremap <return> gf
" Return from last buffer
nnoremap <BS> :b#<CR>

" For switching/opening buffers:
nnoremap <leader>e :e **/*

" For switching buffers next/previous:
nnoremap <C-l> :bn<CR>
nnoremap <C-h> :bp<CR>

" For cycling windows or jump to window:
" 	removed because conflicted with vimwiki bindings
" nnoremap <s-cr> <c-w>w
" nnoremap <number><S-CR> <number><c-w>w

" Moving a line to a different spot
" 	Dont really use this and not sure what to map it to
" nnoremap <leader>k :m .-2<CR>==
" nnoremap <leader>j :m .+1<CR>==
" inoremap <leader>j <Esc>:m .+1<CR>==gi
" inoremap <leader>k <Esc>:m .-2<CR>==gi
" vnoremap <leader>j :m '>+1<CR>gv=gv
" vnoremap <leader>k :m '<-2<CR>gv=gv

" No longer need to press shift to press : in normal and visual mode
nnoremap ; :
vnoremap ; :

" `o` and `O` now only adds new line without going into insert mode
" 	TODO: broken in vimwiki
nnoremap o o<esc>
nnoremap O O<esc>

" -- CUSTOM COMMANDS -- "
" Toggle spell check
let g:spellcheck_is_enabled = 0
set nospell
function! ToggleSpellCheck()
	if g:spellcheck_is_enabled
		let g:spellcheck_is_enabled = 0
		set nospell
		set statusline=Spell\ Check\ Disabled
	else
		let g:spellcheck_is_enabled = 1
		set spell spelllang=en_ca
		set statusline=Spell\ Check\ Enabled
	endif
endfunction
command ToggleSpellCheck call ToggleSpellCheck()
" Enable Spellcheck automatically for relevant files
function! EnableSpellCheck()
	let g:spellcheck_is_enabled = 1
	set spell spelllang=en_ca
endfunction
augroup enable_spellcheck_when_relevant
	autocmd!
	autocmd VimEnter,BufNewFile,BufRead *.md,*.mdown,*.tex,
				\*.txt,*.wiki call EnableSpellCheck()
augroup END

" Toggle Autoindenting Code on filesave
nnoremap g= :let b:PlugView=winsaveview()<CR>gg=G:call winrestview(b:PlugView) <CR>

" -- OTHER -- "

" Setting tab size
set tabstop=4
set shiftwidth=4
set softtabstop=4
"set expandtab

" Show relative line numbers on sidebar
set nu
set relativenumber

" Always shows at least 2 lines around the cursor
set scrolloff=2

" Makes `set list` visually more clear to show invisible chars
set listchars=eol:??,tab:>??,trail:~,extends:>,precedes:<,space:???

" Vim clipboard and System clipboard are shared
" (Requires vim to be compiled to support this to work)
" (On Arch this means you need GVim installed)
set clipboard=unnamedplus

" Keep indent when line wraps
set breakindent
set showbreak=\ \ ??

" Don't split words when wrapping
set linebreak

" Faster Drawing
set ttyfast

" Enable folding of code according to the syntax of the language
set foldmethod=syntax
"	alternative: :set foldmethod=indent

" Remember folds when switching buffers
augroup remember_folds
	autocmd!
	"autocmd BufLeave,BufWinLeave ?* mkview | filetype detect
	"autocmd BufReadPost ?* silent! loadview | filetype detect
	autocmd BufWinLeave ?* mkview
	autocmd BufWinEnter ?* silent! loadview
augroup END


" Prefer to split below
set splitbelow

" NVim Specific Configuration
if has('nvim')
	" Allows using mouse to resize window borders
	set mouse+=a
endif

" ----- PLUGIN INITIALIZATION ----- "

" Install VimPlug if it isn't installed
" It will also install all the plugins in this case
if !has('nvim')
	if empty(glob(g:vimplug_dir))
		silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
					\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		autocmd VimEnter * PlugInstall --sync
	endif
else
	if empty(glob(g:vimplug_dir))
		silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
					\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		autocmd VimEnter * PlugInstall --sync
	endif
endif

" Start of adding Vim plugins
if !has('nvim')
	if "source ~/.config/vim/vimrc" == $VIMINIT
		call plug#begin('~/.config/vim/plugged')
	else
		call plug#begin('~/.vim/plugged')
	endif
else
	call plug#begin('~/.config/nvim/plugged')
endif
" Airline UI for top and bottom bars
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Execute Projects and Terminal commands asynchronously
Plug 'skywind3000/asyncrun.vim'

" Searches for custom .vimrc files for specific projects
Plug 'krisajenkins/vim-projectlocal'

" Code Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Zig syntax highlighting and file detection
Plug 'ziglang/zig.vim'
" Markdown Preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 
			\'for': ['markdown', 'vim-plug']}
" Autogenerate Markdown Table of Contents
Plug 'mzlogin/vim-markdown-toc'

" Latex Compiling and Preview
Plug 'lervag/vimtex'

" Sophisticated Multi-Line Editing
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" File Templates
"Plug 'tibabit/vim-templates'
" Live Preview of HTML/CSS/JS
" 	outdated parser, but plugin in development
"Plug 'turbio/bracey.vim'
call plug#end()
" End of adding Vim plugins

" ----- PLUGIN CONFIG ----- "
" The following is plugin configuration as well as
" vanilla vim settings tailored for the plugins installed

" Search for first custom .vimrc Vim can find to load
" It does this by recursively looking up directories until it finds one
let g:projectlocal_project_markers = ['.vimrc']
" When executing a project or terminal command
" automatically open a new Vim Window of size 7
let g:asyncrun_open = 7

" Sets Airline Theming
let g:airline_theme='distinguished'
let g:airline#extensions#tabline#enabled=1
" Commands to change dark and light themes
command LightTheme AirlineTheme silver
command DarkTheme AirlineTheme distinguished

" Theme Changes
" Disabled for now
" hi Pmenu ctermbg=black ctermfg=white
" hi PmenuSel guibg=yellow guifg=black
" hi Pmenu ctermbg=gray guibg=purple
" hi Folded guibg=#422552 guifg=#00dddd

" Vimwiki configs
" change symbols used for checkboxes
"let g:vimwiki_listsyms = ' ~???' "?????????
"" Makes code completion suggestions work with vimwiki files
"augroup ft_vimwiki
"	au!
"	au BufRead,BufNewFile *.wiki set filetype=vimwiki
"augroup END

" Coc configs
" Fix autocompletion adding a newline while in visual multi mode
augroup coc_autocomplete_newline
	au!
	autocmd User visual_multi_mappings  imap <buffer><expr> <CR> pumvisible() ? "\<C-Y>" : "\<Plug>(VM-I-Return)"
augroup END

" what program should vimtex use to show live edits
" let g:vimtex_view_method = 'zathura'
let g:vimtex_view_general_viewer = 'atril'
" what flavour vimtex should use for autocomplete
let g:tex_flavor = 'latex'
" function for counting words in a latex file
function! WC()
	let filename = expand("%")
	let cmd = "detex " . filename . " | wc -w | perl -pe 'chomp; s/ +//;'"
	let result = system(cmd)
	echo result . " words"
endfunction
" the command for calling the function
command WordCount call WC()

" Make vimwiki use Markdown
let g:vimwiki_list = [{'path': '~/vimwiki/',
			\ 'syntax': 'markdown', 'ext': '.md'}]
