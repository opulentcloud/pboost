# == Schema Information
#
# Table name: delayed_job_results
#
#  id         :integer          not null, primary key
#  job_id     :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class DelayedJobResult < ActiveRecord::Base
  has_one :batch_file, as: :attachable
end
