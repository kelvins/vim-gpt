" Author: Kelvin Salton <http://github.com/kelvins>
" Plugin: https://github.com/kelvins/vim-gpt

if exists("g:loaded_gpt")
    finish
endif
let g:loaded_gpt = 1

command! -nargs=0 GPT call gpt#GPT()
