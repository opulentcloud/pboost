# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  type            :string(255)      not null
#  attachable_type :string(255)      not null
#  attachable_id   :integer          not null
#  mime_type       :string(255)      not null
#  origin_url      :string(255)      not null
#  description     :string(255)      not null
#  attached_file   :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Attachment < ActiveRecord::Base
  # begin associations
  belongs_to :attachable, polymorphic: true
  # end associations
  
  # begin validations
  validates_presence_of :mime_type
  validates_presence_of :origin_url
  validates_presence_of :description
  # end validations
  
protected

  def ext_from_file_format(format)
    case format
      when 'PDF'
        '.pdf'
      when 'PNG'
        '.png'
      when 'JPG'
        '.jpg'
      else
        raise "Attachment#ext_from_file_format #{format} is unknown."
      end
  end

  def ext_from_file_type(file_type)
    case file_type
      when 'image/jpg', 'image/jpeg'
        '.jpg'
      when 'image/png'
        '.png'
      when 'application/pdf'
        '.pdf'
      else
        raise "Attachment.ext_from_fle_type #{file_type.to_s} is not a known value."
    end
  end

end
