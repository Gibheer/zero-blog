module Routes
  class Welcome < Controller
    def self.get(session)
      session.options[:render] = 'posts/index'
    end
  end
end
