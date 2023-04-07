" Author: Kelvin Salton <http://github.com/kelvins>
" Plugin: https://github.com/kelvins/vim-gpt

" Prevents the plugin from being loaded multiple times
if exists("g:loaded_gpt")
    finish
endif
let g:loaded_gpt = 1

" GPT command must be called with at least 1 argument
command! -nargs=0 GPT call gpt#GPT()
