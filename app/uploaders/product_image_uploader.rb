# encoding: utf-8

class ProductImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  
  storage :file
  
  process :resize_to_fit => [200, 267]

  version :big_thumb do
    process :resize_to_limit => [80, 107]
  end

  version :small_thumb do
    process :resize_to_limit => [50, 67]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  def store_dir
    'uploads'
  end


end
