module Decorators
  module AccountInfo
    def self.wrap(user)
      user.extend(self)
    end

    def account_id
      self.id
    end

    def as_json(options = {})
      options[:methods] ||= :account_id
      super(options)
    end

    def to_s
      %w(id email first_name last_name account_id).collect { |k| "#{k}=#{self.send(k)}&" }.join.gsub!(/.{1}$/,'')
    end
  end
end
