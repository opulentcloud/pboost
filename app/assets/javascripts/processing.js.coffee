$(".processing.show").ready ->
  url = $("input#refresh-url").val()
  setRefresh url, 2000
  return
