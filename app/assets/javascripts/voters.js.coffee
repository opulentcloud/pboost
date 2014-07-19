jQuery ->

  $(".voters.search").ready ->

    $('a#print-candidate-petition').on 'click', (event) ->
      event.preventDefault()
      url = $(this).prop('href') + '&petition_header_id=' + $('select#petition-header').val()
      window.location.href = url

