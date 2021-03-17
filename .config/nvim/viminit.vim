source $HOME/.config/nvim/plugins.vim
source $HOME/.config/nvim/settings.vim
source $HOME/.config/nvim/keyboard.vim
source $HOME/.config/nvim/vim-fugitive.vim

if !exists(":DeleteAllBuffers")
  " bda to close all buffers
  command DeleteAllBuffers :bufdo bd
  cnoreabbrev bda DeleteAllBuffers
endif

command! ReloadVimConfig :source $MYVIMRC

" Flash highlight yanked region
 au TextYankPost * silent! lua vim.highlight.on_yank {higroup="Substitute", timeout=200}

" \q to delete buffer without closing window
map <leader>q :bp<CR>:bd#<CR>

" Section: terminal
if !exists(":Vterm")
  command Vterm :vs|:term
endif
if !exists(":Hterm")
  command Hterm :sp|:term
endif
autocmd TermOpen term://* startinsert " Start terminal in insert mode

" auto-reload vimrc configuration
augroup myvimrchooks
  au!
  autocmd bufwritepost $HOME/.config/nvim/init.vim source $HOME/.config/nvim/init.vim
augroup END

" Options for mksession command
augroup vimsessionhooks
  au!
  
  function! SaveSess()
    if len(getbufinfo({'buflisted':1})) > 0
      execute 'mksession! .vimsession.vim'
    elseif filereadable('.vimsession.vim')
      " Clear vimsession if no buffers open
      delete('.vimsession.vim')
    endif
  endfunction

  function! RestoreSess()
    if filereadable('.vimsession.vim')
      execute 'source .vimsession.vim'
    endif
  endfunction


  " autocmd VimLeave * call SaveSess()
  nnoremap <C-s> call SaveSess()<CR>
  autocmd VimEnter * call RestoreSess()
augroup END

" if exists('+termguicolors')
  " let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  " let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  " set termguicolors
" endif
let g:nord_cursor_line_number_background = 1
colorscheme codedark

" Dont show wordcount in airline status
let g:airline#extensions#wordcount#enabled = 0
let g:airline_theme = 'codedark'

" Section: fzf
" ctrl+p to launch fzf
nmap <C-p> :Files<CR>
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let $FZF_DEFAULT_COMMAND='rg --files --ignore-case --hidden -g "!{.git,node_modules}/*"'
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4 --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

" Section: Commentry
nmap <C-_> :Commentary<CR>
nmap <D-/> :Commentary<CR>

" Section: Vim Markdown
" support front matter of various format
let g:vim_markdown_frontmatter = 1  " for YAML format
let g:vim_markdown_toml_frontmatter = 1  " for TOML format
let g:vim_markdown_json_frontmatter = 1  " for JSON format

let g:goyo_width='80%'

if !exists(":PreviewMarkdown")
  command PreviewMarkdown :vs term://pandoc % \| lynx -stdin
endif

" Section: Global Searching
nnoremap <C-f> :Rg<CR>
" nnoremap <C-f> :vimgrep  **/*<L>

let g:vim_json_syntax_conceal = 0
set conceallevel=0 " Never conceal
