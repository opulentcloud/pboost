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

class VerificationImport < Attachment
  mount_uploader :attached_file, BulkVerifyImportUploader
end
