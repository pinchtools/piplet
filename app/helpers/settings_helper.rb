module SettingsHelper

  def setting(*path)
    value = Setting[path.shift]

    return if value.nil?
    return value if path.empty?

    last_key = path.pop

    path.each do |k|
      value = value.fetch(k, {})
    end

    value.fetch(last_key, nil)
  end
end