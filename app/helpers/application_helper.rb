module ApplicationHelper
  def fix_url(url)
    url.starts_with?('http://') ? url : "http://#{url}"
  end

  def print_date(dt)
    dt.strftime("%I:%M%P %Z on %B %d, %Y")
  end
end
