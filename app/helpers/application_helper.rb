module ApplicationHelper
  def fix_url(url)
    url.starts_with?('http://') ? url : "http://#{url}"
  end

  def print_date(dt)
    if logged_in? && !current_user.time_zone.blank?
      dt = dt.in_time_zone(current_user.time_zone)
    end
    dt.strftime("%I:%M%P %Z on %B %d, %Y")
  end

  def set_pagination_range(current_page, page_count)
    pagination_per_page = PostsController::PAGINATION_PER_PAGE
    return [*1..page_count] if page_count <= pagination_per_page

    if current_page > pagination_per_page/2
      if page_count <= (current_page - pagination_per_page/2 + pagination_per_page)
        min = page_count - pagination_per_page + 1
        max = page_count
      else
        min = current_page - pagination_per_page/2 + 1
        max = min + pagination_per_page - 1
      end
      [*min..max]
    else
      [*1..pagination_per_page]
    end
  end
end
