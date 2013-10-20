class Application
  def initialize(start, defaults = {})
    @start = start
    @defaults = defaults
  end

  def call(env)
    session = Session.new(
      ::Zero::Request.new(env),
      ::Zero::Response.new,
      @defaults.clone
    )
    worker = @start
    while not worker.nil?
      worker = worker.call(session)
    end
    session.response.to_a
  end
end
