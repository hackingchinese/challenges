# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :display do
    process :resize_to_fit => [200, 200]
  end

  version :thumb do
    process :resize_to_fit => [25, 25]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    "avatar.jpg" if original_filename
  end

  def get_version_dimensions
    if !file
      [0, 0]
    else
      `identify -format "%wx%h" #{file.path}`.split(/x/)
    end
  end
end

