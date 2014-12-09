module ApplicationHelper
  def challenge_link(index)
    source = @games[index]
    if source
      (link_to 'result' , level_show_game_path(source.id) , class:'btn btn-info' ) + ' ' +
      if source.is_success
        link_to 'Successful , Replay »' , level_game_path(index) , class:'btn btn-success'
      else
        link_to 'Challenge fails , Replay »' , level_game_path(index) , class:'btn btn-warning'
      end
    else
      link_to 'Play »' , level_game_path(index) , class:'btn btn-warning'
    end
  end
end
