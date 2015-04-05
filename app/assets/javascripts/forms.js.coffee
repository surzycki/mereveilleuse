$ ->
  # prevent enter from submittig form
  if $('form').length
    $('form').on 'keypress', (e) ->
      if e.keyCode == 13
        return false

    $('#recommendation_form_patient_type_id').change ->
      if this.value == ''
        $(this).closest('.form-group').find('i').addClass('hidden')
      else
        $(this).closest('.form-group').find('i').removeClass('hidden')
    
  