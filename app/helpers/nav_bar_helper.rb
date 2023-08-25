module NavBarHelper
  def navigation_items
    return [] unless current_user
    
    items = []

    items << { text: "Your annual leave", href: root_path, active: is_current?(root_path) }
    items << { text: "Sign out", href: destroy_user_session_path }
    
    items
  end

  def is_current?(link)
    recognized = Rails.application.routes.recognize_path(link)
    recognized[:controller] == params[:controller] &&
      recognized[:action] == params[:action]
  end
end
