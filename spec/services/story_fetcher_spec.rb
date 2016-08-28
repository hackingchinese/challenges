require 'spec_helper'

describe StoryFetcher do
  specify 'parses HC Blogs' do
    s = StoryFetcher.new('http://www.hackingchinese.com/anki-a-friendly-intelligent-spaced-learning-system/', nil)
    VCR.use_cassette 'hc.1' do
      s.run
    end
    expect(s.valid?).to be == true
    expect(s.title).to include "Anki"
    expect(s.description).to be_present
    expect(s.image_cache).to be_present
    expect(File.exists?("public/uploads/tmp/" + s.image_cache)).to be == true
  end

  specify 'relative urls in image' do
    s = StoryFetcher.new('https://www.stefanwienert.de/', nil)
    VCR.use_cassette 'hc.2', record: :new_episodes do
      s.run
    end
    expect(s.valid?).to be == true
    expect(s.image_cache).to be_present
    expect(File.exists?("public/uploads/tmp/" + s.image_cache)).to be == true
  end

end
