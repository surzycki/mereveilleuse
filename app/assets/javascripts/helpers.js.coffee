window.is_canvas = ->
  e = undefined
  ref = undefined
  try
    return if (ref = window.self != window.top) != null then ref else 'true': false
  catch _error
    e = _error
    return true
