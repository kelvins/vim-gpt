" Author: Kelvin Salton <http://github.com/kelvins>
" Description: Entry point for the gpt.vim plugin

" Global variables
let g:gpt_model = get(g:, 'gpt_model', 'gpt-3.5-turbo')
let g:gpt_temperature = get(g:, 'gpt_temperature', 0.7)
let g:gpt_preview = get(g:, 'gpt_preview', 1)
let g:gpt_preview_wincolor = get(g:, 'gpt_preview_wincolor', 'Visual')

let s:env_api_key = get(environ(), 'OPENAI_API_KEY', '')
let g:gpt_api_key = get(g:, 'gpt_api_key', s:env_api_key)

function! gpt#GPT()
    if g:gpt_api_key == ""
        call gpt#util#echo("OPENAI_API_KEY not defined!")
        return
    endif

    let l:prompt = gpt#util#prompt()

    if l:prompt == ""
        return
    endif

    call gpt#util#echo("Requesting...")

    let s:response = gpt#client#request(l:prompt)

    if s:response == ["null"]
        call gpt#util#echo("Something went wrong! Please try again!")
        return
    else
        call gpt#util#echo("")
    endif

    if g:gpt_preview == 1
        call gpt#popup#create(s:response)
    else
        call gpt#util#write(s:response)
    endif
endfunction
