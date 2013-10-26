module Routes
  class Post < Controller
    def self.get(session)
      posts = DB[:posts].
        filter(:released => true).
        select(:posts__id___post_id, :written, :title, :content).
        join(:accounts, :id___account_id => :account_id).
        reverse_order(:written)
      posts = posts.where(:posts__id => session.options[:id]) if session.options[:id]
      puts posts.literal(:account__id___account_id)
      session.options[:posts]  = posts
      session.options[:render] = 'posts/index'
    end
  end
end
