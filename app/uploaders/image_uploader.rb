class ImageUploader < ApplicationUploader


  version :thumb do
    process resize_to_fit: [70, 70]
  end

  version :medium do
    process resize_to_fit: [300, 300]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    if original_filename
      extension = File.extname(original_filename)
      @file_name ||= "#{Time.now.to_i}-snapshot#{extension}"
    end
  end

end
