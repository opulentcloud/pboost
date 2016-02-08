jQuery ->
  $(".voters.search").ready ->

    $('a#print-candidate-petition').on 'click', (event) ->
      event.preventDefault()
      url = $(this).prop('href') + '&petition_header_id=' + $('select#petition-header').val() + '&petition_header_circulator_id=' + $('select#petition-header-circulator').val()
      window.location.href = url

    $("#voter-Modal").on "hidden.bs.modal", ->
      $(this).removeData "bs.modal"
      return

    $('select#petition-header').change (e) ->
      $.ajax '../petition_headers/' + Number($(e.target).val()),
        type: 'GET'
        dataType: 'script'
        #data: {
        #  center_id: $(e.target).val()
        #}
        error: (jqXHR, textStatus, error) ->
          #console.log("AJAX Error: #{textStatus}")
        success: (data, textStatus, jqXHR) ->
          #console.log("AJAX Success!")
