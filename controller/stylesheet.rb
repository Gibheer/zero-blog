module Routes
  class Stylesheet
    def self.call(session)
      session.options[:render] = 'stylesheet/index'
      session.options[:renderer]
    end
  end
end
