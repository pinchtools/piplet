class LogPresenter < BasePresenter

  def message
    (!!(@model.message =~ /\Alogs\.messages\./)) ? I18n.t(@model.message, @model.message_vars) : @model.message
  end

  def level
    levels = [ "normal", "warning", "danger" ]

    levels[ @model.level - 1 ]
  end

  def data
    "<samp>" + JSON.pretty_generate(@model.data).gsub("\n","<br/>") + "</samp>" if @model.data.present?
  end

  def action_user
    user = User.select(:username).find_by_id(action_user_id)

    user.username if user.present?
  end

end