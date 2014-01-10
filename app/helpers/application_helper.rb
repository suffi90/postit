module ApplicationHelper
  def fix_url(url)
    url.starts_with?('http://') ? url : "http://#{url}"
  end

  def print_date(date)
    Time.at(date.to_i).strftime("%I:%M%p on %B %d, %Y")
  end
end
