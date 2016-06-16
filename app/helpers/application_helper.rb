module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end


  def markdown(html)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render(html).html_safe
  end

  def progress_bar(max: 100, percent:, title: "#{percent.round(1)}%", inside_text: title, outside_text: '')
    content_tag :progress, class: 'progress js-tooltip', value: percent, max: max, title: title do
      inside_text
      # concat content_tag(:div, class: 'progress-bar', style: "width: #{percent}%", 'aria-valuenow' => percent, 'aria-valuemin' => 0, role: 'progressbar') { inside_text }
      # concat outside_text
    end
  end

  def twitter_share_url(text: '', url: request.url)
    "https://twitter.com/share?#{{ text: text, url: url}.to_query}"
  end
end
