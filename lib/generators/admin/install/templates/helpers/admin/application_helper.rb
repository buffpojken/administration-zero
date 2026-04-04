module Admin::ApplicationHelper
  include Pagy::Frontend

  def title
    content_for(:title) || Rails.application.class.to_s.split("::").first
  end

  def active_nav_item(*names)
    names.include?(controller_path) ? "active" : ""
  end

  def pagy_nav(pagy, **)
    link  = ->(page, label, attrs = "") { %(<a href="#{pagy_url_for(pagy, page)}" #{attrs}>#{label}</a>) }
    btn   = "inline-flex items-center justify-center w-8 h-8 text-sm rounded-md border transition-colors"
    page  = "#{btn} border-gray-300 text-gray-700 bg-white hover:bg-gray-50"
    curr  = "#{btn} border-blue-600 bg-blue-600 text-white font-medium"
    ghost = "#{btn} border-gray-200 text-gray-300 bg-white cursor-not-allowed"

    html = +%(<nav class="flex items-center gap-1" aria-label="Pages">)

    html << if pagy.prev
      link.(pagy.prev, "&#8249;", %(class="#{page}" aria-label="Previous page"))
    else
      %(<span class="#{ghost}" aria-disabled="true">&#8249;</span>)
    end

    pagy.series.each do |item|
      html << case item
      when Integer then link.(item, item, %(class="#{page}"))
      when String  then %(<span class="#{curr}" aria-current="page">#{item}</span>)
      when :gap    then %(<span class="inline-flex items-center px-1 text-sm text-gray-400">&#8230;</span>)
      end
    end

    html << if pagy.next
      link.(pagy.next, "&#8250;", %(class="#{page}" aria-label="Next page"))
    else
      %(<span class="#{ghost}" aria-disabled="true">&#8250;</span>)
    end

    html << "</nav>"
    html.html_safe
  end
end
