module Routes
  class Post < Controller
    def self.get(session)
      define_posts(session)
      session.options[:render] = 'posts/index'
    end

    def self.define_posts(session)
      posts = DB[:posts].
        filter(:released => true).
        select(:posts__id___post_id, :written, :title, :content, :username).
        join(:accounts, :id___account_id => :account_id).
        reverse_order(:written)
      if session.options[:id]
        posts = posts.where(:posts__id => session.options[:id]) 
      end
      session.options[:posts]  = posts
    end
  end
end
