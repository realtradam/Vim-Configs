" press F5 to execute the project code
map <f5> :AsyncRun -cwd=<root> ruby run.rb<CR>

" Identify .mab files as Ruby
augroup syntax_mab_files
	autocmd!
	autocmd VimEnter,BufNewFile,BufRead *.mab set syntax=ruby
augroup end
