xml.instruct!
xml.rss(version: "2.0", "xmlns:atom"=>"http://www.w3.org/2005/Atom", "xmlns:content"=>"http://purl.org/rss/1.0/modules/content/", "xmlns:dc"=>"http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title "Hacking Chinese Resources Feed #{@filter.title}"
    xml.link @filter.current_path
    xml.lastBuildDate Time.now
    xml.tag!('atom:link', rel: 'self', type: 'application/rss+xml', href: request.url)
    @filter.stories.each do |story|
      image = nil
      image = image_url story.image.url(:medium) if story.image.present?
      xml.item do
        xml.title story.title
        xml.link story.url
        xml.guid url=resources_story_url(story)
        xml.comments url
        xml.pubDate story.created_at.rfc822
        xml.tag!("dc:creator", story.user.name)
        xml.comments url

        xml.tag!("content:encoded") do
          xml.cdata!  <<-DOC
          <table border=0>
          <tr>
          <td>
          #{image_tag( image, style: 'float: left; margin-right:5px') if image }
          </td>
          <td>
          #{simple_format story.description}
          <br/>
          #{link_to("Read more", url)}
          </td></tr></table>
          DOC
        end
        xml.description do
          xml.cdata! <<-DOC
          <table border=0>
          <tr>
          <td>
          #{image_tag( image, style: 'float: left; margin-right:5px') if image }
          </td>
          <td>
          #{truncate(story.description, length: 200)}
          <br/>
          #{link_to("Read more", url)}
          </td></tr></table>
          DOC
        end
        if image
          xml.image do
            xml.url image
          end
          xml.enclosure(url: image, type: 'image/jpg', length: story.image.versions[:medium].size)
        end
        story.tags.each do |tag|
          xml.category tag.name
        end
      end
    end
  end
end
