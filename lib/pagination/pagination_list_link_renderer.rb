class PaginationListLinkRenderer < WillPaginate::ActionView::LinkRenderer

  protected

  def page_number(page)
    unless page == current_page
      tag(:li, link(page, page, :rel => rel_value(page)))
    else
      tag(:li, page, :class => "current")
    end
  end

  def previous_or_next_page(page, text, classname)
    if page
      tag(:li, link(text, page), :class => classname)
    else
      tag(:li, text, :class => classname + ' disabled')
    end
  end

  def html_container(html)
    tag(:ul, html, container_attributes)
  end

end