module ApplicationHelper

  def markdown(html)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render(html).html_safe
  end

  def progress_bar(max: nil, value: nil, percent: value * 100 / max, title: "#{percent}%", inside_text: title, outside_text: '')
    content_tag :div, class: 'progress js-tooltip', title: title do
      concat content_tag(:div, class: 'progress-bar', style: "width: #{percent}%", 'aria-valuenow' => percent, 'aria-valuemin' => 0, role: 'progressbar') { inside_text }
      concat outside_text
    end
  end

end
