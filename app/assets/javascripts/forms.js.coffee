$ ->
  # prevent enter from submittig form
  if $('form').length
    $('form').on 'keypress', (e) ->
      if e.keyCode == 13
        return false
    
  