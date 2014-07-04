module ApplicationHelper

  def link_to_add_fields(name, f, type)
    new_object = f.object.send "build_#{type}"
    id = "new_#{type}"
    fields = f.send("#{type}_fields", new_object, child_index: id) do |builder|
      render('orders/' + type.to_s + '_fields', f: builder)
    end
    link_to('#', class: 'add_fields btn btn-default', data: {id: id, fields: fields.gsub('\n', '')}) do
      "#{name} #{content_tag(:span, "", class: "glyphicon glyphicon-plus-sign", title: "Add Search Condition")}".html_safe
    end
  end

end
