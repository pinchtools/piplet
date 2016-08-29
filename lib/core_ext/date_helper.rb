module ActionView::Helpers::DateHelper
  
  def distance_of_time_from_now_with_direction(time)
    if time > Time.now
      I18n.t("datetime.distance_in_words_with_directions.future", distance: distance_of_time_in_words_to_now(time) )
    else
      I18n.t("datetime.distance_in_words_with_directions.past", distance: distance_of_time_in_words_to_now(time) )
    end
  end
  
end