" Section: fzf
" ctrl+p to launch fzf
nnoremap <C-p> :Files<CR>
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let $FZF_DEFAULT_COMMAND='rg --files --ignore-case --hidden -g "!{.git,node_modules}/*"'
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4 --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

