class Rack::Attack
  BANTIME = 10.minutes.freeze

  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  Rack::Attack.blocklist('fail2ban pentesters') do |req|
    cache_id = "pentesters-#{req.ip}-#{req.user_agent}"

    conditions = [
      { maxretry: 5, findtime: 10.seconds },
      { maxretry: 6, findtime: 5.minutes },
      { maxretry: 30, findtime: 1.hour },
    ]

    conditions.each do |condition|
      Rack::Attack::Fail2Ban.filter(cache_id, condition.merge(bantime: BANTIME)) do
        # The count for the IP is incremented if the return value is truthy
        self.attack?(req)
      end
    end

    Rack::Attack::Fail2Ban.banned?(cache_id)
  end

  Rack::Attack.blocklisted_response = lambda do |env|
    [ 503, {}, [File.read(Rails.public_path.join('503.html'))]]
  end

  def self.attack?(req)
    req.path == Rails.application.routes.url_helpers.login_path && req.post?
  end
end