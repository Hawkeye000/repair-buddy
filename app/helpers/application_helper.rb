module ApplicationHelper

  def active_home_link(link)
    params[:id] == 'home' ? active = "active" : active = ""
    content_tag :li, class:active, id:'nav_home_link' do
      link_to "Home", link
    end
  end

  def active_my_records_link(link)
    return nil unless current_user
    params[:controller] == 'records' && params[:action] == 'index' ? active = "active" : active = ""
    content_tag :li, class:active, id:'nav_my_records_link' do
      link_to "My Records", link
    end
  end

end
