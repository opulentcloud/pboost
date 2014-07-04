refreshPage = (url) ->
  $.getScript url
  return
setRefresh = (url, seconds) ->
  setTimeout "refreshPage('" + url + "')", seconds
  return
window.refreshPage = refreshPage
window.setRefresh = setRefresh

