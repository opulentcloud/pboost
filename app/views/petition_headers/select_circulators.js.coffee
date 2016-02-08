<%- if @circulators.exists? %>
$('select#petition-header-circulator').empty().append("<option value=\"\">\n (Choose a circulator or leave blank)\n</option>");
$('select#petition-header-circulator').append("<%= escape_javascript(render(partial: 'circulator', collection: @circulators)) %>");
<%- else %>
$('select#petition-header-circulator').empty().append("<option value=\"\">\n (Choose a circulator or leave blank)\n</option>");
<% end %>
