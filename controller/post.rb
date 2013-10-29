module Routes
  class Post < Controller
    def self.get(session)
      define_posts(session)
      session.options[:render] = 'posts/index'
    end

    def self.define_posts(session)
      page     = (session.request.params['page'] || 0).to_i
      per_page = (session.request.params['per_page'] || 10).to_i
      posts = DB[:posts].
        filter(:released => true).
        select(:posts__id___post_id, :written, :title, :content, :username).
        join(:accounts, :id___account_id => :account_id).
        reverse_order(:written)
      if session.options[:id]
        posts = posts.where(:posts__id => session.options[:id]) 
      end
      session.options[:posts]  = posts.limit(per_page, page * per_page)
    end
  end
end
