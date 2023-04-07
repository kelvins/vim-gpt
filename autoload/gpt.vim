" Author: Kelvin Salton <http://github.com/kelvins>
" Description: Entry point for the gpt.vim plugin

" Global variables
let g:openai_model = get(g:, 'openai_model', 'gpt-3.5-turbo')
let g:openai_temperature = get(g:, 'openai_temperature', 0.7)
let g:openai_api_key = get(environ(), 'OPENAI_API_KEY', '')

function! gpt#GPT()
    if g:openai_api_key == ""
        call gpt#util#echo("OPENAI_API_KEY not defined!")
        return
    endif

    let l:prompt = gpt#util#prompt()

    call gpt#util#echo("Requesting...")

    let s:response = gpt#client#request(l:prompt)

    if s:response == ["null"]
        call gpt#util#echo("Something went wrong! Please try again!")
    else
        call gpt#popup#create(s:response)
    endif
endfunction
