class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  # end

  version :thumb do
    process :resize_to_fit => [70, 70]
  end

  version :medium do
    process :resize_to_fit => [300, 300]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    "snapshot.jpg" if original_filename
  end

end
