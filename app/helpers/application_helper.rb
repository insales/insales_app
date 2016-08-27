module ApplicationHelper
  def flash_messages
    message_divs = []
    [:error, :notice].each do |key|
      next unless (massage = flash[key])
      message_p = content_tag(:p, massage, class: key)
      message_divs << content_tag(:div, message_p, class: "message")
    end
    flash.clear # Защита для того, чтобы не вывести flash дважды
    content_tag :div, message_divs.join(''), { id: "flash_messages" }, false
  end

  def home_path
    "http://#{account_domain}/admin/home"
  end

  def account_domain
    session[:shop] || current_account.insales_subdomain
  end

  def app_name
    APP_NAME
  end

  def email_tech_support
    EMAIL_TECH_SUPPORT
  end
end
