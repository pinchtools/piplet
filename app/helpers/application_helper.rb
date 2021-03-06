module ApplicationHelper
  
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = I18n.t 'site.title'
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def present(model, presenter_class=nil)
    klass = presenter_class || "#{model.class}Presenter".constantize
    presenter = klass.new(model, self)
    yield(presenter) if block_given?
  end

  def detect_language
    http_accept_language.preferred_language_from(I18n.available_locales) ||
        http_accept_language.compatible_language_from(I18n.available_locales)
  end

end
