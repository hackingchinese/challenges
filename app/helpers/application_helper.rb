module ApplicationHelper

  def nav_link(text, path, li_class: 'nav-item', a_class: 'nav-link')
    active = request.path == path ? 'active' : ''

    content_tag :li, class: li_class do
      link_to text, path, class: "#{a_class} #{active}"
    end
  end

  def highlight_search_term(string)
    if params[:q]
      highlight(string, params[:q].split(' '))
    else
      string
    end
  end

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
    @_renderer ||= Redcarpet::Render::HTML.new(
      link_attributes: { rel: :nofollow }
    )
    @_markdown ||= Redcarpet::Markdown.new(@_renderer, autolink: true, safe_links_only: true, no_styles: true, tables: true,
                                          link_attributes: { rel: :nofollow })
    @_markdown.render(html).html_safe
  end

  def progress_bar(max: 100, percent:, title: "#{percent.round(1)}%", inside_text: title, outside_text: '')
    content_tag :progress, class: 'progress js-tooltip', value: percent, max: max, title: title do
      inside_text
    end
  end

  def twitter_share_url(text: '', url: request.url)
    "https://twitter.com/share?#{{ text: text, url: url}.to_query}"
  end

  def pretty_print_url(url)
    URI.parse(url).tap{|uri| uri.scheme = nil; uri.query = nil }.to_s.sub('www.', '').sub('//','')
  end

  # TODO
end
