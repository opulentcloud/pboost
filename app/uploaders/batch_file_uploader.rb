class BatchFileUploader < CarrierWave::Uploader::Base
  storage :fog
  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(csv jpg jpeg gif png pdf txt xls xlsx)
  end
  
  def process_uri(uri)
    URI.parse(uri)
  end
end
