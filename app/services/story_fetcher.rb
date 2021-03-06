class StoryFetcher
  attr_reader :title, :description, :image_cache, :error, :url, :response

  def initialize(url, existing_story_id)
    @url = url
    @existing_story_id = existing_story_id.presence
  end

  def valid?
    @error.nil?
  end

  def run
    if url.blank? or !url[%r{^https?://}]
      @error = "This is not a valid url"
      return false
    end
    @url.gsub!(/\??utm_source.*/, '')
    if !@existing_story_id && (dupe = Resources::Story.find_by(url: @url))
      @error = "Link already submitted by #{dupe.user.name} on #{dupe.created_at.to_date}!<br/> <a href='/resources/stories/#{dupe.id}'>Link</a>"
      return false
    end

    @response = get(url)
    if @response.success?
      handle_response
    elsif response.timed_out?
      @error = "Time out while reaching server"
    elsif response.code == 0
      @error = "Network error: #{response.return_message}"
    else
      @error = "HTTP-Error: #{response.code}"
    end

    !@error
  end

  private

  def get(url)
    Typhoeus.get(url,
      followlocation: true,
      accept_encoding: "gzip",
      timeout: 60,
      headers: {
        "User-agent" => "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:27.0) Gecko/20100101 Firefox/Firefox27.0",
        "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        'Accept-Language' => 'en-us;q=0.5,en;q=0.36'
      })
  end

  def handle_response
    parse_content
    dummy_story = Resources::Story.new
    if @image
      response = get(@image)
      if response.success?
        tf = Tempfile.new(["image_download", ".jpg"])
        tf.binmode
        tf.write response.body
        tf.flush
        dummy_story.image = tf
      end
    end
    if dummy_story.image.blank? and !RUBY_PLATFORM['darwin']
      dummy_story.image = screenshot
    end
    if dummy_story.image.present?
      @image_cache = dummy_story.image_cache
    end
  end

  def parse_content
    doc = Nokogiri::HTML.parse(@response.body.to_s)
    text = doc.css('meta[property="og:description"], meta[itemprop=description],meta[name=description], meta[name="twitter:description"]').
      map { |i| i['content'] }.uniq.compact.max(&:length)
    image = doc.css('meta[property="og:image"],meta[name="twitter:image:src"],meta[name="image"]').map { |i| i['content'] }.uniq.compact.first
    @title = doc.at('title, h1').try(:text).try(:strip)
    @description = text.try(:strip)
    @image = image
    if @image && @image.starts_with?("/")
      @image = Addressable::URI.join(response.request.url, @image).to_s
    end
  end

  def screenshot
    file = Tempfile.new(['screenshot', '.jpg'])
    file.binmode
    Headless.ly do
      `wkhtmltoimage  --transparent --use-xserver --width 1200 --height 900 #{Shellwords.escape(url)} #{file.path}`
    end
    if $CHILD_STATUS.to_i == 0
      file
    end
  end
end
