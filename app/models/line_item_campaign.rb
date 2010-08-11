class LineItemCampaign < ActiveRecord::Base
	belongs_to :line_item
	belongs_to :campaign
end
