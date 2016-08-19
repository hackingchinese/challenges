class ApplicationUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def resize_to_fit(width, height)
    manipulate! do |img|
      MiniMagick::Tool::Mogrify.new do |mogrify|
        mogrify.resize "#{width}x#{height}"
        mogrify.background 'white'
        mogrify.flatten
        mogrify << img.path
      end
      img = yield(img) if block_given?
      img
    end
  end
end
