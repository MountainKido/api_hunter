module ApplicationHelper
  def challenge_link_check(index , link)
    session[:checked] ||= {}
    if session[:checked][index.to_s]
      link_to 'Success!!' , link , class:'btn btn-success'
    else
      link_to 'Play »' , link , class:'btn btn-warning'
    end
  end
end