class UserFilter::ApplyWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :critical

  THROTTLE_TIME = 5

  def perform(filter_id)
    @filter = UserFilter.find(filter_id)

    @filter.log(:apply_filter)

    concerned_users = (@filter.email_provider.present?) ? users_with_provider : users_with_ip

    concerned_users.in_batches do |relation|
      @filter.users << relation
      sleep(THROTTLE_TIME)
    end
  end

  private

  def users_with_provider
    User.where(blocked: false).where("email LIKE ?", "%@#{@filter.email_provider}")
  end

  def users_with_ip
    User.where(blocked: false).where("creation_ip_address <<= ?", @filter.cidr_address.to_cidr_s)
  end
end