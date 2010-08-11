class LineItemContactList < ActiveRecord::Base
	belongs_to :line_item
	belongs_to :contact_list
end
