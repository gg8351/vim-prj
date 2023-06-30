function! PickSelectorDefinition()
  let saved_view = winsaveview()
  defer winrestview(saved_view)

  let selector = expand('<cword>')
  if search('\zs\%(id\|class\)\ze="\k*\%#\k*"') < 0
    return
  endif
  let selector_type = expand('<cword>')

  if selector_type == 'id'
    exe 'vimgrep /^#'.selector.' {/j *.css'
  elseif selector_type == 'class'
    exe 'vimgrep /^\.'.selector.' {/j *.css'
  else
    return
  endif

  let matches = getqflist()->mapnew({ i, entry -> [bufname(entry.bufnr), entry.text] })
  let texts = matches->mapnew({ i, match -> $"{i + 1} {match[1]} (in file: {match[0]})" })
  let files = matches->mapnew({ _, match -> match[0] })

  let choices = extend(["Pick one"], texts)
  let choice_index = inputlist(choices) - 1

  exe 'vertical split '.files[choice_index]
endfunction