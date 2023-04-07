" Author: Kelvin Salton <http://github.com/kelvins>
" Description: OpenAI API client

let s:openai_url = "https://api.openai.com/v1/chat/completions"

function! gpt#client#build(prompt)
    let l:payload = [
        \ "{\\\"model\\\": \\\"" . g:gpt_model . "\\\",",
        \ "\\\"temperature\\\": " . g:gpt_temperature . ",",
        \ "\\\"messages\\\": [{\\\"role\\\": \\\"user\\\", \\\"content\\\": \\\"" . a:prompt . "\\\"}]}",
        \ ]
    let l:command = [
        \ 'curl -s ' . s:openai_url,
        \ '-H "Content-Type: application/json"',
        \ '-H "Authorization: Bearer ' . g:gpt_api_key . '"',
        \ '-d "' . join(l:payload, " ") . '"'
        \ ]
    return join(l:command, " ")
endfunction

function! gpt#client#request(prompt)
    let l:json_parser = 'jq -r ".choices[0].message.content"'
    let l:command = gpt#client#build(a:prompt) . " | " . l:json_parser
    return [l:command]
    "return split(system(l:command), "\n")
endfunction
