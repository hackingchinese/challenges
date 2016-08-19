class ImageUploader < ApplicationUploader

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
