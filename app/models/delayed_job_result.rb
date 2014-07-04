class DelayedJobResult < ActiveRecord::Base
  has_one :batch_file, as: :attachable
end
