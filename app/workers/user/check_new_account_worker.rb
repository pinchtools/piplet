class User::CheckNewAccountWorker
  include Sidekiq::Worker

  def perform(user_id)
    scopes = []
    scopes << :all_blocked if User.signaled_matching_with_blocked_account
    scopes << :suspects if User.signaled_matching_with_suspected_account

    user = User.find user_id

    scopes.each do |scope|
      break if found_similiraty(user, scope) do |attribute, value, similar_value|
        key_scope = (scope == 'all_blocked') ? 'blocked' : 'suspected'
        user.suspect(note: "user.errors.username.similar-to-#{key_scope}-one")

        user.log(:suspected,
            message: "log.messages.#{attribute}_similar",
            message_vars: { value: value, match: similar_value } )
      end
    end
  end

  def found_similiraty(user, scope)
    ['username', 'email'].each do |attribute|
      if match = user.send("find_#{attribute}_similar_on_scope", scope)
        yield(attribute, user.send(attribute), match)
        return true
      end
    end
    return false
  end
end