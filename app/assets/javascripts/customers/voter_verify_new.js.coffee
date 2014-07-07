jQuery ->
  $(".voter_verify.new").ready ->
    $('input#reset_button').on 'click', (event) ->
      $('div#results').hide()
      $('input#voter_last_name').focus()
      return true

  $(".voter_verify.search").ready ->
    $('input#reset_button').on 'click', (event) ->
      $('div#results').hide()
      $('input#voter_last_name').focus()
      return true    
