# encoding: utf-8

class SacredSymbolImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  
  storage :file

  process :resize_to_fit => [200, 200]

  version :small_thumb do
    process :resize_to_limit => [60, 60]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  def store_dir
    'uploads'
  end


end