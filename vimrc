" When creating a custom .vimrc we need to re-enable the defaults
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

" ----- CUSTOM CONFIGURATION DIRECTORY ----- "
"  If you don't care about changing the vim config directory then you can
"  safely ignore this section

" If you wish to use .config/vim directory instead make sure to add the
" following to your .bashrc:
" 	export VIMINIT="source ~/.config/vim/vimrc"
" and place this vimrc into `~/.config/vim/vimrc`.
" Otherwise Vim will configure itself automatically using default directories
if "source ~/.config/vim/vimrc" == $VIMINIT
	" Where to check for vimplug later on
	let g:vimplug_dir = "~/.config/vim/autoload/plug.vim"
	" Used for moving .vim into .config/vim
	set viminfo+=n~/.config/vim/viminfo
	" Create new runtime paths to .config/vim and enforce order
	let rtp=&runtimepath
	set runtimepath=~/.config/vim
	let &runtimepath.=','.rtp.',~/.config/vim/after'
	" Move .viminfo files to .config/vim as well
	set viminfo+=n~/.config/vim/viminfo
else
	" Where to check for vimplug later on
	let g:vimplug_dir = "~/.vim/autoload/plug.vim"
endif

" ----- VANILLA CONFIG ----- "

" -- CUSTOM SHORTCUTS -- "

" Space is used as the 'modifier'/'leader' key
let mapleader = " "

" For searching buffers:
nnoremap <leader>e :e **/
" For switching buffers fast:
nnoremap <leader>l :bn<CR>
nnoremap <leader>h :bp<CR>

" Moving a line to a different spot
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==
inoremap <leader>j <Esc>:m .+1<CR>==gi
inoremap <leader>k <Esc>:m .-2<CR>==gi
vnoremap <leader>j :m '>+1<CR>gv=gv
vnoremap <leader>k :m '<-2<CR>gv=gv

" No longer need to press shift to press : in normal and visual mode
nnoremap ; :
vnoremap ; :

" `o` and `O` now only adds new line without going into insert mode
nnoremap o o<esc>
nnoremap O O<esc>

" -- CUSTOM COMMANDS -- "
" Toggle spell check
let g:spellcheck_is_enabled = 0
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
function! ToggleAutoIndent()
	if !exists('#autoindent_on_save#BufEnter')
		augroup autoindent_on_save
			autocmd!
			autocmd BufWritePre * :normal g=
			set statusline=AutoIndent\ Enabled
		augroup END
	else
		augroup autoindent_on_save
			autocmd!
			set statusline=AutoIndent\ Disabled
		augroup END
	endif
endfunction
command ToggleAutoIndent call ToggleAutoIndent()
call ToggleAutoIndent()

" -- OTHER -- "

" Show relative line numbers on sidebar
set nu
set relativenumber

" Always shows at least 2 lines around the cursor
set scrolloff=2

" Makes `set list` visually more clear to show invisible chars
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:‗

" Vim clipboard and System clipboard are shared
" (Requires vim to be compiled to support this to work)
" (On Arch this means you need GVim installed)
set clipboard=unnamedplus

" Wrap to different line when reaching end or beginning of a line
set whichwrap=b,s,<,>,[,]

" Keep indent when line wraps
set breakindent
set showbreak=\ ·

" Don't split words when wrapping
set linebreak

" Faster Drawing
set ttyfast

" Enable folding of code according to the syntax of the language
set foldmethod=syntax

" Prefer to split below
set splitbelow


" ----- PLUGIN INITIALIZATION ----- "

" Install VimPlug if it isn't installed
" It will also install all the plugins in this case
if empty(glob(g:vimplug_dir))
	if "source ~/.config/vim/vimrc" == $VIMINIT
		silent !curl -fLo ~/.config/vim/autoload/plug.vim --create-dirs
					\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	else
		silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
					\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	endif
	autocmd VimEnter * PlugInstall --sync
endif

" Start of adding Vim plugins
if "source ~/.config/vim/vimrc" == $VIMINIT
	call plug#begin('~/.config/vim/plugged')
else
	call plug#begin('~/.vim/plugged')
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
" Markdown Preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 
			\'for': ['markdown', 'vim-plug']}
" Latex Compiling and Preview
Plug 'lervag/vimtex'
" Vimwiki for writing down notes
Plug 'vimwiki/vimwiki'
" Autogenerate Markdown Table of Contents
Plug 'mzlogin/vim-markdown-toc'
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

" Makes popup text readable
hi Pmenu ctermbg=black ctermfg=white

" what program should vimtex use to show live edits
let g:vimtex_view_method = 'zathura'
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
